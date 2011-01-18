maintainer       "Benedikt Böhm"
maintainer_email "bb@xnull.de"
license          "Apache 2.0"
description      "Configures the base system"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"
supports         "gentoo", ">= 2.0"

depends "git"
depends "munin"
depends "nagios"
depends "node"
depends "portage"