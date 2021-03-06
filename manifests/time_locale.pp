# == Class: profiles::time_locale
#
# Class to call other profiles to manage all the locations requirements
#
# === Variables
#
# All variables from Hiera with no defaults
#
# [*ntp_servers*]
#   Array of ntp servers.
#
# [*timezone*]
#   Which time zone we want to be in.
#
# === Authors
#
# Brett Gray <brett.gray@puppetlabs.com>
#
# === Copyright
#
# Copyright 2014 Puppet Labs, unless otherwise noted.
#
class profiles::time_locale {

  $ntp_servers  = hiera('profiles::time_locale::ntp_servers')
  $timezone     = hiera('profiles::time_locale::timezone')

  validate_array($ntp_servers)

  # manage the default locale
  file_line { 'locale':
    ensure => present,
    path   => '/etc/sysconfig/i18n',
    line   => "LANG=${locale}",
    match  => 'LANG=',
  }

  # manage timezone
  class { '::timezone':
    timezone => $timezone,
  }

  # lets manage some NTP stuff
  class { '::ntp':
    servers => $ntp_servers,
  }
}
