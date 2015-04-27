#!/usr/bin/env ruby

require 'cloudformation-ruby-dsl/cfntemplate'
require 'net/http'
require 'uri'
require 'erb'
require 'pp'

# t2.* can only use ebs
BACK    = 'ebs-ssd'

# no need for i386 anymore
ARCH    = 'amd64'

# let's use pvm
VMTYPE  = 'paravirtual'

# keypair to use for ubuntu user
KEYPAIR = 'hbarnes'

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
    rel,
    rel_type,
    rel_stage,
    rel_num,
    rel_backing,
    rel_arch,
    rel_region,
    rel_id,
    rel_kernel,
    rel_vmtype = line.split(/\t/)
    next unless rel_region == region && rel_arch == ARCH &&
                rel_backing == BACK  && rel_vmtype = VMTYPE
    id = rel_id
  end

  id
end
# cloudformation-ruby-dsl can interpolate CloudFormation items in the userdata using the form:
#   {{function(param)}}
# We are setting the cloudformation references here for them to be interpolated at the last moment.
def template
  <<-EOF.gsub(/^ {4}/, '')
    #!/bin/bash

    # install basics
    apt-get update
    apt-get install git wget

    # install chef
    wget https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/chefdk_0.4.0-1_amd64.deb
    dpkg -i chefdk_0.4.0-1_amd64.deb
    rm -f chefdk_0.4.0-1_amd64.deb

    # setup cookbooks
    mkdir -p /tmp/chef_solo
    git clone git@github.com:harlanbarnes/how-i-work.git /tmp/chef_solo

    # vendor cookbooks
    cd /tmp/chef_solo/how-i-work/cookbook
    berks vendor /tmp/chef_solo/cookbooks

    # setup node configuration
    echo '<%= node_json %>' > /tmp/chef_solo/node.json

    # setup chef solo configuration
    mkdir -p /tmp/chef_solo/file_cache_path
    echo '
      file_cache_path "/tmp/chef_solo/file_cache_path"
      cookbook_path "/tmp/chef_solo/cookbooks"
      json_attribs "/tmp/chef_solo/node.json"
    ' > /tmp/chef_solo/solo.rb

    chef-solo -c /tmp/chef_solo/solo.rb -j /tmp/chef_solo/node.json >> /var/log/chef.log 2>&1 &
  EOF
end

def userdata(type)
  node = {}

  case type
  when 'web'
    node['web'] = {}

    # for lack of service discovery, we "ask" the CloudFormation template to give us the private DNS
    # name of the application instances we want to proxy.
    node['run_list'] = %w(recipe[sample::web])
    node['web']['backends'] = []

    COUNT[:app].times do |index|
      index +=1
      node['web']['backends'].push("{{get_att('app#{index}', 'PrivateDnsName')}}")
    end
  when 'app'
    node['app'] = {}
    node['run_list'] = %w(recipe[sample::app])
  end

  node_json = JSON.generate(node)
  begin
    result = ERB.new(template, 3, '>').result(binding)
  rescue Exception => e
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
      resource "app#{index}", Type: 'AWS::EC2::Instance',
        Properties: {
          ImageId: image_id('trusty', aws_region),
          InstanceType: 't2.micro',
          SecurityGroupIds: [ref('SimpleSecurityGroup')],
          KeyName: KEYPAIR,
          UserData: base64(interpolate(userdata(app))),
          Tags: [
            { Key: 'Name', Value: "app#{index}" }
          ]
        }
    end

    COUNT[:web].times do |index|
      index += 1
      resource "web#{index}", Type: 'AWS::EC2::Instance',
        Properties: {
          ImageId: image_id('trusty', aws_region),
          InstanceType: 't2.micro',
          SecurityGroupIds: [ref('SimpleSecurityGroup')],
          KeyName: KEYPAIR,
          UserData: base64(interpolate(userdata(web))),
          Tags: [
            { Key: 'Name', Value: "web#{index}" }
          ]
        }
    end
end.exec!
