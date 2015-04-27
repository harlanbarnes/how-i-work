name             'simple'
maintainer       'Harlan Barnes'
maintainer_email 'hbarnes@pobox.com'
license          'Apache 2.0'
description      'Installs simple web and app server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION')).chomp

depends 'apt', '~> 2.7.0'
depends 'nginx', '~> 2.7.6'
depends 'nrpe', '~> 1.5.0'
depends 'os-hardening', '~> 1.2.0'
depends 'ssh-hardening', '~> 1.0.3'
