# == Class: profiles::ir4wls
#
# Class to manage Weblogic
#
# === Variables
#
# All variables from Hiera with no defaults, except datasource (and default)
#
# [*jdk_home_dir*]
#
# [*nodemanager_port*]
#
# [*os_group*]
#
# [*os_user*]
#
# [*version*]
#
# [*weblogic_home_dir*]
#
# [*wls_setting*]
#
# [*adminserver_control_list*]
#
# [*adminserver_control_defaults*]
#
# [*wls_setting_instances*]
#
# [*wls_setting_defaults*]
#
# [*managed_servers*]
#
# [*managed_servers_defaults*]
#
# [*cluster_instances*]
#
# [*cluster_instances_defaults*]
#
# [*datasource*]
#
# [*datasource_defaults*]
#
# === Authors
#
# Brett Gray <brett.gray@puppetlabs.com>
#
# === Copyright
#
# Copyright 2014 Puppet Labs, unless otherwise noted.
#
class profiles::ir4wls {

  # Hiera lookups
  $jdk_home_dir                 = hiera('profiles::ir4wls::jdk_home_dir')
  $nodemanager_port             = hiera('profiles::ir4wls::nodemanager_port')
  $os_group                     = hiera('profiles::ir4wls::os_group')
  $os_user                      = hiera('profiles::ir4wls::os_user')
  $version                      = hiera('profiles::ir4wls::version')
  $weblogic_home_dir            = hiera('profiles::ir4wls::weblogic_home_dir')
  $wls_setting                  = hiera('profiles::ir4wls::wls_setting_instances')
  $adminserver_control_list     = hiera('profiles::ir4wls::adminserver_list')
  $adminserver_control_defaults = hiera('profiles::ir4wls::adminserver_defaults')
  $wls_setting_instances        = hiera('profiles::ir4wls::wls_setting')
  $wls_setting_defaults         = hiera('profiles::ir4wls::wls_defaults')
  $managed_servers              = hiera('profiles::ir4wls::managed_servers')
  $managed_servers_defaults     = hiera('profiles::ir4wls::managed_servers_defaults')
  $cluster_instances            = hiera('profiles::ir4wls::cluster_instances')
  $cluster_instances_defaults   = hiera('profiles::ir4wls::cluster_instances')
  $datasource                   = hiera('profiles::ir4wls::datasource', {}),
  $datasource_defaults          = hiera('profiles::ir4wls::datasource_defaults', {})

  # Ensure NodeManager is running
  ir4wls::nodemanager{'NodeManager1036':
    jdk_home_dir      => $jdk_home_dir,
    nodemanager_port  => $nodemanager_port,
    os_group          => $os_group,
    os_user           => $os_user,
    version           => $version,
    weblogic_home_dir => $weblogic_home_dir,
  }

  # Ensure AdminServers are running
  create_resources('ir4wls::control', $adminserver_control_list, $adminserver_control_defaults)

  # Domain Init for further Cutover Actions
  create_resources('wls_setting', $wls_setting_instances, $wls_setting_defaults)

  ## Managed Server Cutover
  create_resources('wls_server', $managed_servers, $managed_servers_defaults)
  create_resources('wls_cluster', $cluster_settings, $cluster_instances_defaults)

  ## Datasource Cutover
  create_resources('ir4wls::dspassword',$datasource, $datasource_defaults)

  ## Sequence Settings
  Ir4wls::Nodemanager<| |>    ->
  Ir4wls::Control<| |>        ->
  Wls_setting<| |>            ->
  Wls_server<| |>             ->
  Wls_cluster<| |>            ->
  Ir4wls::Dspassword<| |>


/*
       ## Subscribing on changes to related Managed Servers
       $is_enable_subscribe = hiera('is_enable_subscribe_managed_servers')
       if $is_enable_subscribe == 'false' {
          $subscribe_server_list = hiera('subscribe_server_list', {})
          create_resources('wls_managedserver',$subscribe_server_list, $weblogic_password)
       }
*/
    }

}
