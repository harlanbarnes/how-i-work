require 'spec_helper'

describe 'simple::app' do
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
      simple::_security
      apt::default
      simple::_nginx
      simple::_nrpe
    ).each do |recipe|
    it "includes the #{recipe} recipe" do
      expect(chef_run).to include_recipe(recipe)
    end
  end

  it 'installs the git package' do
    expect(chef_run).to install_package('git')
  end

  it 'creates the /root/.ssh directory' do
    expect(chef_run).to create_directory('/root/.ssh')
  end

  it 'creates the /root/.ssh/config file from the cookbook' do
    expect(chef_run).to create_cookbook_file('/root/.ssh/config')
  end

  it 'creates the /var/www/how-i-work directory' do
    expect(chef_run).to create_directory('/var/www/how-i-work')
  end

  it 'syncs the git repo' do
    expect(chef_run).to sync_git('/var/www/how-i-work').with(repository: 'https://github.com/harlanbarnes/how-i-work.git')
  end

  it 'creates the simple-site template for nginx' do
    expect(chef_run).to create_template('/etc/nginx/sites-available/simple-site')
  end

  it 'enables the simple-site in nginx' do
    expect(chef_run).to enable_nginx_site('simple-site')
  end

  it 'enables nrpe check_simple_site' do
    expect(chef_run).to add_nrpe_check('check_simple_site')
  end

end