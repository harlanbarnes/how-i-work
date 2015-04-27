require 'spec_helper'

describe 'simple::web' do
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

  it 'creates the simple-proxy template for nginx' do
    expect(chef_run).to create_template('/etc/nginx/sites-available/simple-proxy')
  end

  it 'enables the simple-proxy in nginx' do
    expect(chef_run).to enable_nginx_site('simple-proxy')
  end

  it 'enables nrpe check_simple_proxy' do
    expect(chef_run).to add_nrpe_check('check_simple_proxy')
  end

end