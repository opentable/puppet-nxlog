class nxlog (
  $service_enabled    = false,
  $install_dir        = "c:\\nxlog",
  $logging_config     = {
                          'iis' => {
                            'host'   => 'logstash',
                            'port'   => '1938',
                            'fields' => 'date time s-sitename s-computername s-ip cs-method cs-uri-stem cs-uri-query s-port cs-username c-ip cs-version cs(User-Agent) cs(Cookie) cs(Referer) cs-host sc-status sc-substatus sc-win32-status sc-bytes cs-bytes time-taken',
                          },
                          'eventlogs' => {
                            'host' => 'logstash',
                            'port' => '1935'
                          },
                          'infrastructure' => {
                            'host' => 'logstash',
                            'port' => '1937'
                          }
                        },
) {
  $script = 'c:\puppet_script_folder'
  $nxlog_file = 'nxlog-ce-2.7.1191.msi'
  $nxlog_dest = "${script}\\${nxlog_file}"

  ensure_resource('file', $script, { ensure => directory} )

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
