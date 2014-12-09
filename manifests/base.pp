# == Class: profiles::base
#
# Class to call other profiles to manage all the base requirements
#
#
# === Variables
#
# All variables from Hiera with no defaults
#
# [*enable_firewall*]
#   Boolean to determine if firewall is managed.
#
# [*packages*]
#   Array of random packages to install.
#
# === Authors
#
# Brett Gray <brett.gray@puppetlabs.com>
#
# === Copyright
#
# Copyright 2014 Puppet Labs, unless otherwise noted.
#
class profiles::base {

  $enable_firewall  = hiera('profiles::base::enable_firewall')
  $packages         = hiera_array('profiles::base::packages')

  validate_bool($enable_firewall)
  validate_array($packages)

  # This must be in place to do anything else
  require profiles::repos

  # manage some base packages
  ensure_packages($packages)

  # manage time, timezones, and locale
  #class { 'profiles::time_locale': }

  # manage shells available
  class { 'profiles::security': }

  # manage SSH
  #class { 'profiles::ssh': }

  # manage SUDO
  class { 'profiles::sudo': }

  # manage logging
  class { 'profiles::logging': }

  # manage DNS stuff
  #class { 'profiles::dns': }

  # manage Email stuff
  class { 'profiles::mail': }

  # authentication
  #class { 'profiles::auth': }

  # firewall
  if $enable_firewall {
    class { 'firewall': }
    class { 'profiles::firewall_pre': }
    class { 'profiles::firewall_post': }
  }

}
