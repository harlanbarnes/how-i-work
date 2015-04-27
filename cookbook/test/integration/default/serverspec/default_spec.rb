require 'serverspec'

set :backend, :exec

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin:/bin:/usr/bin'
  end
end

describe "Simple App and Web Stack" do

  %w(nginx nagios-nrpe-server ssh).each do |s|
    it "should have service #{s} enabled for boot and running" do
      expect(service(s)).to be_enabled
      expect(service(s)).to be_running
    end
  end

  {'nginx' => %w(80 8080), 'nagios-nrpe-server' => '5666', 'openssh-server'  => 22}.each do |name, list|
    list = [ list ] unless list.kind_of?(Array)
    list.each do |p|
      it "should have service #{name} listening on port #{p}" do
        expect(port(p)).to be_listening
      end
    end
  end

  %w(nginx nagios-nrpe-server git openssh-server).each do |name|
    it "has package #{name} installed by apt" do
      expect(package(name)).to be_installed.by('apt')
    end
  end

  it 'has the site checked out at /var/www/how-i-work/site' do
    expect(file('/var/www/how-i-work/site/index.html')).to contain('marvel.com')
  end

  it 'has the site served up from port 80' do
    expect(command('wget -q -O - http://localhost/ | grep -q marvel.com').exit_status).to equal(0)
  end

end
