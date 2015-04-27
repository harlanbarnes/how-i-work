require 'spec_helper'

describe 'simple::_security' do
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

  %w(
      os-hardening::default
      ssh-hardening::server
    ).each do |recipe|
    it "includes the #{recipe} recipe" do
      expect(chef_run).to include_recipe(recipe)
    end
  end

end