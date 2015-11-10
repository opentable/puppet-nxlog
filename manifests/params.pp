class nxlog::params {
  $service_enabled = false
  $install_dir     = "c:\\nxlog"

  $configuration = {
    'iis' => {
      'host'   => 'logstash',
      'port'   => '1938',
      'fields' => 'date time s-ip cs-method cs-uri-stem cs-uri-query s-port cs-username c-ip cs(User-Agent) cs(Referer) sc-status sc-substatus sc-win32-status sc-bytes cs-bytes time-taken',
    },
    'eventlog' => {
      'host' => 'logstash',
      'port' => '1935'
    },
    'infrastructure' => {
      'host' => 'logstash',
      'port' => '1937'
    }
  }
}
