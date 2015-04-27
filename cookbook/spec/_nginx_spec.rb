require 'spec_helper'

describe 'simple::_nginx' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.automatic["platform_family"] = "debian"
      node.automatic["lsb"]["codename"] = "trusty"
    end.converge(described_recipe)
  end

  before do
    stub_command("find /bin  -perm -go+w -type f | wc -l | egrep '^0$'").and_return(0)
    stub_command("find /sbin  -perm -go+w -type f | wc -l | egrep '^0$'").and_return(0)
    stub_command("find /usr/bin  -perm -go+w -type f | wc -l | egrep '^0$'").and_return(0)
    stub_command("find /usr/sbin  -perm -go+w -type f | wc -l | egrep '^0$'").and_return(0)
    stub_command("find /usr/local/sbin  -perm -go+w -type f | wc -l | egrep '^0$'").and_return(0)
    stub_command("find /usr/local/bin  -perm -go+w -type f | wc -l | egrep '^0$'").and_return(0)
    stub_command("which nginx").and_return("/usr/sbin/nginx")
  end

  it "includes the nginx::default recipe" do
    expect(chef_run).to include_recipe('nginx::default')
  end

  %w(conf.d/default.conf conf.d/example_ssl.conf).each do |file|
    it "deletes the file /etc/nginx/#{file}" do
      expect(chef_run).to delete_file("/etc/nginx/#{file}")
    end
  end

end