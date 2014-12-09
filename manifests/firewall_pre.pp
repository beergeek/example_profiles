# == Class: profiles::firewall_pre
#
# Pre actions for firewall management.
#
#
# === Authors
#
# Brett Gray <brett.gray@puppetlabs.com>
#
# === Copyright
#
# Copyright 2014 Puppet Labs, unless otherwise noted.
#
class profiles::firewall_pre {

  Firewall {
    require => undef,
  }

  # Default firewall rules
  firewall { '000 accept all icmp':
    proto  => 'icmp',
    action => 'accept',
    before => Firewall['001 accept all to lo interface'],
  }

  firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
    before  => Firewall['002 accept related established rules'],
  }

  firewall { '002 accept related established rules':
    proto   => 'all',
    state => ['RELATED', 'ESTABLISHED'],
    action  => 'accept',
    before  => Firewall['003 accept ssh'],
  }

  firewall { '003 accept ssh':
    proto   => 'all',
    action  => 'accept',
  }
}
