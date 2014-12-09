# == Class: profiles::puppet_backup
#
# Class to manage backups on Primary Puppet Master.
# For use only in PE3.3.2.
#
# === Variables
#
# [*dump_path*]
#   Absolute path for Postgresql dumps.
#   Required.
#
# [*secondary_master*]
#   Hostname (FQDN) of Secondary (Passive) Master.
#   Optional
#
# [*rsync_user*]
#   User for rsync job to Secondary (Passive) Master.
#   Required if `secondary_master` is present.
#
# === Authors
#
# Brett Gray <brett.gray@puppetlabs.com>
#
# === Copyright
#
# Copyright 2014 Puppet Labs, unless otherwise noted.
#
class profiles::puppet_backup {

  # hiera lookups
  $dump_path        = hiera('profiles::puppet_backup::dump_path')
  $secondary_master = hiera('profiles::puppet_backup::secondary_master', undef)

  if $secondary_master {
    # variables
    $incron_ssl_condition = "${::settings::ssldir}/ca/signed IN_CREATE,IN_DELETE,IN_MODIFY"
    $rsync_ssl_dir        = '/etc/puppetlabs/puppet/ssl/ca'

    # if we are going to send to secondary master we need some rysnc info
    $rsync_user = hiera('profiles::puppet_backup::rsync_user')

    ensure_packages(['rsync','incron'])

    file { '/etc/incron.d/sync_certs':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0744',
      content => "${incron_ssl_condition} rsync -apu /etc/puppetlabs/puppet/ssl/* ${rsync_user}@${secondary_master}:${rsync_ssl_dir}/\n",
      require => Package['incron'],
    }

    service { 'incrond':
      ensure    => running,
      enable    => true,
      subscribe => File['/etc/incron.d/sync_certs'],
    }
  }

  # posgresq dumps
  file { 'dump_directory':
    ensure => directory,
    path   => $dump_path,
    owner  => 'pe-postgres',
    group  => 'root',
    mode   => '0755',
  }

  cron { 'puppet_console_dumps':
    ensure   => present,
    command  => "su - pe-postgres -s /bin/bash -c '/opt/puppet/bin/pg_dump -Fc -C -c -p 5432 console' > ${dump_path}/console_`date +'%Y%m%d%H%M'`",
    user     => 'root',
    hour     => '23',
    minute   => '30',
    monthday => '*',
    require  => File['dump_directory'],
  }

  cron { 'puppet_console_auth_dumps':
    ensure   => present,
    command  => "su - pe-postgres -s /bin/bash -c '/opt/puppet/bin/pg_dump -Fc -C -c -p 5432 console_auth' > ${dump_path}/console_auth_`date +'%Y%m%d%H%M'`",
    user     => 'root',
    hour     => '23',
    minute   => '30',
    monthday => '*',
    require  => File['dump_directory'],
  }

  cron { 'puppet_puppetdb_dumps':
    ensure   => present,
    command  => "su - pe-postgres -s /bin/bash -c '/opt/puppet/bin/pg_dump -Fc -C -c -p 5432 pe-puppetdb' > ${dump_path}/pe-puppetdb_`date +'%Y%m%d%H%M'`",
    user     => 'root',
    hour     => '23',
    minute   => '30',
    monthday => '*',
    require  => File['dump_directory'],
  }
}
