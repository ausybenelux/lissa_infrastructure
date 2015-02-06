name             "phing"
maintainer       'CrossCheck'
maintainer_email 'support@crosscheck.be'
license          'All rights reserved'
description      "Installs/Configures Phing"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

depends "php"

recipe "phing", "Installs Phing"
