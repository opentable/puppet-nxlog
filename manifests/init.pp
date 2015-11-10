class nxlog (
  $service_enabled = $nxlog::params::service_enabled,
  $install_dir     = $nxlog::params::install_dir,
  $configuration   = $nxlog::params::configuration,
) inherits nxlog::params {

  $script = 'c:\puppet_script_folder'
  $nxlog_file = 'nxlog-ce-2.7.1191.msi'
  $nxlog_dest = "${script}\\${nxlog_file}"

  ensure_resource('file', $script, { ensure => directory } )

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

  $service_status = $service_enabled ? {
    true  => 'running',
    false => 'stopped',
  }
  service { 'nxlog' :
    ensure  => $service_status,
    require => Package['NXLOG-CE'],
  }

  file { "${install_dir}\\conf\\nxlog.conf" :
    ensure  => present,
    content => template('nxlog/nxlog.conf.erb'),
    require => Package['NXLOG-CE'],
    notify  => Service['nxlog'],
  }
}
