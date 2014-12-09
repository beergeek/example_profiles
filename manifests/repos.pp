# == Class: profiles::repos
#
# Class to call other profiles to manage all the repo requirements
# Tagged with 'bootstrap' so can be performed before all other runs.
#
# === Variables
#
# All variables from Hiera with no defaults
#
# [*repo_hash*]
#   Nested hash of details for yumrepo type.
#
# [*repo_defaults*]
#   Hash of defaults for yumrepo type.
#
# === Authors
#
# Brett Gray <brett.gray@puppetlabs.com>
#
# === Copyright
#
# Copyright 2014 Puppet Labs, unless otherwise noted.
#
class profiles::repos {
  $repo_hash      = hiera('profiles::repos::repo_hash')
  $repo_defaults  = hiera('profiles::repos::repo_defaults')

  create_resources('yumrepo', $repo_hash, $repo_defaults)

}
