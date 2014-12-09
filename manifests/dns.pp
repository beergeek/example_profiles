# == Class: profiles::dns
#
# Class to call other profiles to manage all the dns requirements
#
#
# === Variables
#
# All variables from Hiera with no defaults
#
# [*default_search*]
#   Default searh domain for /etc/resolv.conf.
#
# [*extended_search*]
#   Array of extended search servers for /etc/resolv.conf.
#
# [*name_servers*]
#   Array of name servers for /etc/resolv.conf.
#
# === Authors
#
# Brett Gray <brett.gray@puppetlabs.com>
#
# === Copyright
#
# Copyright 2014 Puppet Labs, unless otherwise noted.
#
class profiles::dns {

  $default_search   = hiera('profiles::dns::default_search')
  $extended_search  = hiera('profiles::dns::extended_search')
  $name_servers     = hiera('profiles::dns::name_servers')

  validate_array($extended_search)
  validate_array($name_servers)

  class { '::resolv':
    default_search  => $default_search,
    extended_search => $extended_search,
    name_servers    => $name_servers
  }
}
