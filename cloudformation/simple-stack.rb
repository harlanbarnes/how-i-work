#!/usr/bin/env ruby

require 'cloudformation-ruby-dsl/cfntemplate'
require 'net/http'
require 'uri'
require 'erb'
require 'pp'

# instance because these nodes are ephemeral
BACK    = 'instance-store'

# no need for i386 anymore
ARCH    = 'amd64'

# let's use pvm
VMTYPE  = 'paravirtual'

# keypair to use for ubuntu user
KEYPAIR = ENV['AWS_KEYPAIR_NAME'] || 'hbarnes'

# instance mapping/count for later expansion
COUNT = {
  web: 1,
  app: 2
}

def index(release)
  return @index[release] if @index && @index[release]
  @index = {} unless @index

  url = "https://cloud-images.ubuntu.com/query/#{release}/server/released.txt"
  uri = URI.parse(url)

  begin
    response = Net::HTTP.get_response uri
  rescue
    raise "Could not fetch url: #{url}"
  end

  @index[release] = response.body
end

# In most cases we'd just hardcode the image id as a constant OR a mapping of ids in the
# CloudFormation template. This is just an example of what being in a ruby environment
# can deliver.
def image_id(release, region)
  id = nil

  # There's a nuance to the data that's not obvious here. The image id list at Ubuntu's site is
  # ordered so that the latest releases are added to the bottom. Thus, we will pick up the latest
  # release number (rel_num below) on each pass.
  index(release).split(/\n/).each do |line|
    _rel,
    _rel_type,
    _rel_stage,
    _rel_num,
    rel_backing,
    rel_arch,
    rel_region,
    rel_id,
    _rel_kernel,
    _rel_vmtype = line.split(/\t/)
    next unless rel_region == region && rel_arch == ARCH &&
                rel_backing == BACK  && rel_vmtype == VMTYPE
    id = rel_id
  end

  id
end
# cloudformation-ruby-dsl can interpolate CloudFormation items in the userdata using the form:
#   {{function(param)}}
# We are setting the cloudformation references here for them to be interpolated at the last moment.
def userdata_template
  <<-EOF.gsub(/^ {4}/, '')
    #!/bin/bash

    LOG=/var/log/userdata.log

    echo "* let's have a look at the ENV"
    env >> $LOG

    echo "* apt-update and setup basics" >> $LOG
    apt-get update >> $LOG 2>&1
    apt-get install git wget --yes >> $LOG 2>&1

    echo "* install chefdk" >> $LOG
    wget -q https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.4.0-1_amd64.deb >> $LOG 2>&1
    dpkg -i chefdk_0.4.0-1_amd64.deb >> $LOG 2>&1
    rm -f chefdk_0.4.0-1_amd64.deb >> $LOG 2>&1

    # apparently the userdata environment is very basic so berks/ruby goes bonkers
    echo "* setting up the environment for chefdk and missing variables"
    eval "$(chef shell-init bash)"
    export HOME=/root
    export USER=root
    export LANGUAGE=en_US.UTF-8
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8

    echo "* setup working directory"
    mkdir -p /tmp/chef_solo/how-i-work >> $LOG 2>&1

    echo "* clone repo" >> $LOG
    git clone https://github.com/harlanbarnes/how-i-work.git /tmp/chef_solo/how-i-work >> $LOG 2>&1

    echo "* berks vendor cookbook" >> $LOG
    cd /tmp/chef_solo/how-i-work/cookbook >> $LOG 2>&1
    berks vendor /tmp/chef_solo/cookbooks >> $LOG 2>&1
    cd - > /dev/null

    echo "* setup node json" >> $LOG
    echo '<%= node_json %>' > /tmp/chef_solo/node.json

    echo "* setup chef solo configuration" >> $LOG
    mkdir -p /tmp/chef_solo/file_cache_path >> $LOG 2>&1
    echo '
      file_cache_path "/tmp/chef_solo/file_cache_path"
      cookbook_path "/tmp/chef_solo/cookbooks"
      json_attribs "/tmp/chef_solo/node.json"
    ' > /tmp/chef_solo/solo.rb

    echo "* execute chef solo" >> $LOG
    chef-solo -c /tmp/chef_solo/solo.rb -j /tmp/chef_solo/node.json >> $LOG 2>&1 &
  EOF
end

def userdata(type)
  node = {}

  case type
  when 'web'
    node['web'] = {}

    # for lack of service discovery, we "ask" the CloudFormation template to give us the private DNS
    # name of the application instances we want to proxy.
    node['run_list'] = %w(recipe[simple::web])
    node['web']['backends'] = []

    COUNT[:app].times do |index|
      index += 1
      node['web']['backends'].push("{{get_att('app#{index}', 'PrivateDnsName')}}")
    end
  when 'app'
    node['app'] = {}
    node['run_list'] = %w(recipe[simple::app])
  end

  node_json = JSON.generate(node)
  begin
    result = ERB.new(userdata_template, 3, '>').result(binding)
  rescue StandardError => e
    raise "Could not create userdata from template: #{e}"
  end
end

template do
  tag Application: 'Simple'

  resource 'SimpleSecurityGroup',
    Type: 'AWS::EC2::SecurityGroup',
    Properties: {
      GroupDescription: 'HTTP (80 and 8080) from world; SSH from bastion; NRPE from fake host',
      SecurityGroupIngress: [
        {
          IpProtocol: 'tcp',
          FromPort: 80,
          ToPort: 80,
          CidrIp: '0.0.0.0/0'
        },
        {
          IpProtocol: 'tcp',
          FromPort: 8080,
          ToPort: 8080,
          CidrIp: '0.0.0.0/0'
        },
        {
          IpProtocol: 'tcp',
          FromPort: 5666,
          ToPort: 5666,
          CidrIp: '192.168.1.1/32'
        },
        {
          IpProtocol: 'tcp',
          FromPort: 22,
          ToPort: 22,
          CidrIp: '24.30.55.196/32'
        }
      ],
      Tags: [{ Key: 'Name', Value: 'default-simple' }]
    }

  COUNT[:app].times do |index|
    index += 1
    resource "app#{index}",
      Type: 'AWS::EC2::Instance',
      Properties: {
        ImageId: image_id('trusty', aws_region),
        InstanceType: 'm1.small',
        SecurityGroupIds: [ref('SimpleSecurityGroup')],
        KeyName: KEYPAIR,
        UserData: base64(interpolate(userdata('app'))),
        Tags: [
          { Key: 'Name', Value: "app#{index}" }
        ]
      }
  end

  COUNT[:web].times do |index|
    index += 1
    resource "web#{index}",
      Type: 'AWS::EC2::Instance',
      Properties: {
        ImageId: image_id('trusty', aws_region),
        InstanceType: 'm1.small',
        SecurityGroupIds: [ref('SimpleSecurityGroup')],
        KeyName: KEYPAIR,
        UserData: base64(interpolate(userdata('web'))),
        Tags: [
          { Key: 'Name', Value: "web#{index}" }
        ]
      }
  end

  output 'URL', Description: 'URL to access application',
    Value: join('', 'http://', get_att('web1', 'PublicDnsName'))
end.exec!
