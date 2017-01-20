# == Class: etcd::config
#
class etcd::config {
  file { $::etcd::config_file_path:
    ensure  => 'file',
    content => template("${module_name}/etc/etcd/etcd.conf.erb"),
  }

  file { '/usr/lib64/systemd/system/etcd2.service':
    ensure  => 'file',
    content => template("${module_name}/etc/etcd2.conf.erb"),
  }

  if $::etcd::manage_package and $::etcd::journald_forward_enable and ($::operatingsystemmajrelease == '7' or 'coreos' in $::operatingsystemrelease) {
    file { '/etc/systemd/system/etcd.service.d':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
    file { '/etc/systemd/system/etcd.service.d/journald.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/journald.conf.erb"),
    } ~>
    exec { 'systemctl-daemon-reload etcd_service':
      refreshonly => true,
      command     => '/usr/bin/systemctl daemon-reload',
    }
  }

  if $::operatingsystemmajrelease == '6' {
    file { '/etc/init.d/etcd':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template("${module_name}/etc/etcd.init"),
    }
  }
}
