require 'spec_helper'

describe 'simple::_nrpe' do
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

  it "includes the nrpe::default recipe" do
    expect(chef_run).to include_recipe('nrpe::default')
  end

  it "creates the remote_file /usr/lib/nagios/plugins/check_mem" do
    expect(chef_run).to create_remote_file('/usr/lib/nagios/plugins/check_mem').with(source: 'https://raw.githubusercontent.com/justintime/nagios-plugins/master/check_mem/check_mem.pl')
  end

  %w(check_load check_mem check_disk check_time check_ssh).each do |name|
    it "enables nrpe #{name}" do
      expect(chef_run).to add_nrpe_check(name)
    end
  end

end