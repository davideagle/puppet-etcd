# == Class: etcd::service
#
# Class to manage the etcd service daemon
#
class etcd::service {
  if $::etcd::manage_service {
    service { 'etcd2.service':
      ensure => $::etcd::service_ensure,
      enable => $::etcd::service_enable,
    }
  }
}
