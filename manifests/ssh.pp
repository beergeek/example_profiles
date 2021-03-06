# == Class: profiles::ssh
#
# Class to call other profiles to manage all the ssh requirements
#
# === Variables
#
# All variables from Hiera with no defaults
#
# [*allowed_groups*]
#   List of groups allowed.
#
# [*banner_content*]
#   Content of banner file.
#
# [*enable_firewall*]
#   Boolean to determine if firewall settings are required.
#
# [*options_hash*]
#   Hash of options for sshd_config.
#
# === Authors
#
# Brett Gray <brett.gray@puppetlabs.com>
#
# === Copyright
#
# Copyright 2014 Puppet Labs, unless otherwise noted.
#
class profiles::ssh {

  $allowed_groups   = hiera_array('profiles::ssh::allowed_groups')
  $banner_content   = hiera('profiles::ssh::banner_content')
  $enable_firewall  = hiera('profiles::ssh::enable_firewall')
  $options_hash     = hiera_hash('profiles::ssh::options_hash')

  validate_bool($enable_firewall)

  if $enable_firewall {
    # include firewall rule
    firewall { '100 allow ssh access':
      port   => '22',
      proto  => 'tcp',
      action => 'accept',
    }
  }

  file { ['/etc/issue','/etc/issue.net']:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $banner_content,
  }

  $ssh_group_hash = {'AllowGroups' => join($allowed_groups, ' ')}

  class { '::ssh::server':
    storeconfigs_enabled => false,
    options              => merge($options_hash, $ssh_group_hash),
  }

}
