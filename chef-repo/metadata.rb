name             'lissa'
maintainer       'ONEAgency'
maintainer_email 'gent@one-agency.be'
license          '(c) 2015 -- All rights reserved'
description      'Installs/Configures LISSA'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'lissa'
depends 'apache2'
depends 'apt'
depends 'build-essential'
depends 'git'
depends 'iptables'
depends 'mysql'
depends 'nginx'
depends 'openssl'
depends 'php'
depends 'phing'
depends 'sudo'
depends 'users'
depends 'vim'