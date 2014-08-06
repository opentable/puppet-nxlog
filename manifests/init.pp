class nxlog (
  $install_dir = "c:\\nxlog",
  $logging_host = 'logstash',
  $logging_port = '1938',
) {

  $script = 'c:\puppet_script_folder'
  $nxlog_file = 'nxlog-ce-2.7.1191.msi'
  $nxlog_dest = "${script}\\${nxlog_file}"

  file { $script :
    ensure => directory,
  }

  file { $nxlog_dest :
    ensure             => present,
    source             => "puppet:///modules/nxlog/${nxlog_file}",
    require            => File[$script],
    mode               => '0755',
    source_permissions => 'ignore',
  }

  package { 'NXLOG-CE':
    ensure          => '2.7.1191',
    source          => $nxlog_dest,
    require         => File[$nxlog_dest],
    install_options => ["INSTALLDIR=${install_dir}"]
  }

  service { 'nxlog' :
    ensure  => running,
    require => Package['NXLOG-CE'],
  }

  file { "${install_dir}\\conf\\nxlog.conf" :
    ensure  => present,
    content => template('nxlog/nxlog.conf.erb'),
    require => Package['NXLOG-CE'],
    notify  => Service['nxlog'],
  }
}
