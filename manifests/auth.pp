# == Class: profiles::auth
#
# Class to call other profiles to manage all the auth requirements
#
#
# === Variables
#
# All variables from Hiera with no defaults
#
# [*admin_server*]
#   Kerberos admin server.
#
# [*dcredit*]
#   Cracklib digit credit number.
#
# [*default_domain*]
#   Kerberos default domain.
#
# [*default_realm*]
#   Kerberos default realm.
#
# [*difok*]
#   Cracklib password difference count.
#
# [*dns_lookup_kdc*]
#   Boolean value to determine if DNS is used for KDC look up.
#
# [*dns_lookup_realm*]
#   Boolean value to determine if DNS is used for realm look up.
#
# [*enable_sssd*]
#   Boolean to determine if SSSD is managed.
#
# [*forwardable*]
#   Boolean value for Kerberos forwadable value.
#
# [*krb5_template*]
#   Template for Kerberos.conf file.
#
# [*lcredit*]
#   Cracklib lowercase credit count.
#
# [*login_defs_template*]
#   Template for login_def file.
#
# [*minlen*]
#   Cracklib minlen for password.
#
# [*ocredit*]
#   Cracklib other character credit count.
#
# [*package_list*]
#   Array of packages to manage for auth.
#
# [*password_auth_ac_template*]
#   Template for passwd_auth_ac file.
#
# [*renew_lifetime*]
#   Renew liftime for Kerberos tickets.
#
# [*sssd_template*]
#   Template for ssssd.conf file.
#
# [*system_auth_ac_template*]
#   Template for system_auth_ac file.
#
# [*ticket_lifetime*]
#   Lifetime for Kerberos tickets.
#
# [*ucredit*]
#   Cracklib uppercase credit count.
#
# === Authors
#
# Brett Gray <brett.gray@puppetlabs.com>
#
# === Copyright
#
# Copyright 2014 Puppet Labs, unless otherwise noted.
#
class profiles::auth {

  $admin_server              = hiera('profiles::auth::admin_server')
  $dcredit                   = hiera('profiles::auth::dcredit')
  $default_domain            = hiera('profiles::auth::default_domain')
  $default_realm             = hiera('profiles::auth::default_realm')
  $difok                     = hiera('profiles::auth::difok')
  $dns_lookup_kdc            = hiera('profiles::auth::dns_lookup_kdc')
  $dns_lookup_realm          = hiera('profiles::auth::dns_lookup_realm')
  $enable_sssd               = hiera('profiles::auth::enable_sssd')
  $forwardable               = hiera('profiles::auth::forwardable')
  $krb5_template             = hiera('profiles::auth::krb5_template')
  $lcredit                   = hiera('profiles::auth::lcredit')
  $login_defs_template       = hiera('profiles::auth::login_defs_template')
  $minlen                    = hiera('profiles::auth::minlen')
  $ocredit                   = hiera('profiles::auth::ocredit')
  $package_list              = hiera('profiles::auth::package_list')
  $password_auth_ac_template = hiera('profiles::auth::password_auth_ac_template')
  $renew_lifetime            = hiera('profiles::auth::renew_lifetime')
  $sssd_template             = hiera('profiles::auth::sssd_template')
  $system_auth_ac_template   = hiera('profiles::auth::system_auth_ac_template')
  $ticket_lifetime           = hiera('profiles::auth::ticket_lifetime')
  $ucredit                   = hiera('profiles::auth::ucredit')

  class { 'sssd':
    admin_server              => $admin_server,
    dcredit                   => $dcredit,
    default_domain            => $default_domain,
    default_realm             => $default_realm,
    difok                     => $difok,
    dns_lookup_kdc            => $dns_lookup_kdc,
    dns_lookup_realm          => $dns_lookup_realm,
    enable_sssd               => $enable_sssd,
    forwardable               => $forwardable,
    krb5_template             => $krb5_template,
    lcredit                   => $lcredit,
    login_defs_template       => $login_defs_template,
    minlen                    => $minlen,
    ocredit                   => $ocredit,
    package_list              => $package_list,
    password_auth_ac_template => $password_auth_ac_template,
    renew_lifetime            => $renew_lifetime,
    sssd_template             => $sssd_template,
    system_auth_ac_template   => $system_auth_ac_template,
    ticket_lifetime           => $ticket_lifetime,
    ucredit                   => $ucredit,
  }

}
