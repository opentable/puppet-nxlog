require 'spec_helper'

describe 'nxlog', :type => :class do
  describe 'nxlog iis only configuration generation' do
    let(:params) {{
      :service_enabled => true,
      :install_dir     => 'c:\nxlog',
      :logging_config  => {
        'iis' => {
          'host'   => 'logstash',
          'port'   => '1938',
          'fields' => 'date time s-sitename s-computername s-ip cs-method cs-uri-stem cs-uri-query s-port cs-username c-ip cs-version cs(User-Agent) cs(Cookie) cs(Referer) cs-host sc-status sc-substatus sc-win32-status sc-bytes cs-bytes time-taken',
        },
      },
    }}

    it { should contain_file('c:\nxlog\conf\nxlog.conf').with({
      :content => /
    Fields        \$date, \$time, \$service, \$server_name, \$host, \$http_method, \$http_path, \$http_querystring, \$server_port, \$http_username, \$client_ip, \$http_version, \$http_useragent, \$http_cookie, \$http_referer, \$http_host, \$http_status_code, \$http_sub_status_code, \$win32_status_code, \$bytes_sent, \$bytes_received, \$duration
    FieldTypes    string, string, string, string, string, string, string, string, integer, string, string, string, string, string, string, string, integer, integer, integer, integer, integer, integer
/,
      }).without({
        :content => /<Input eventlog>/
      }).without({
        :content => /<Output logstash_infrastructure>/
      })
    }

    it { should contain_file('c:\nxlog\conf\nxlog.conf').with({
        :content => /
<Output logstash_iis>
    Module        om_tcp
    Host          logstash
    Port          1938
<\/Output>
/
      })
    }
  end

  describe 'nxlog iis defined without logging host' do
    let(:params) {{
      :service_enabled => true,
      :install_dir     => 'c:\nxlog',
      :logging_config  => {
        'iis' => {
          'port' => '1938',
        },
      },
    }}

    it do
      expect { should compile }.to raise_error(Puppet::Error, /iis logging host cannot be nil or empty/)
    end
  end

  describe 'nxlog iis defined without logging port' do
    let(:params) {{
      :service_enabled => true,
      :install_dir     => 'c:\nxlog',
      :logging_config  => {
        'iis' => {
          'host' => 'logstash',
        },
      },
    }}

    it do
      expect { should compile }.to raise_error(Puppet::Error, /iis logging port cannot be nil or empty/)
    end
  end

  describe 'nxlog iis only configuration generation' do
    let(:params) {{
      :service_enabled => true,
      :install_dir     => 'c:\nxlog',
      :logging_config  => {
        'eventlog' => {
          'host'   => 'logstash',
          'port'   => '1935',
        },
      },
    }}

    it { should contain_file('c:\nxlog\conf\nxlog.conf').without({
        :content => /<Output logstash_iis>/,
      }).with({
        :content => /<Input eventlog>/
      }).without({
        :content => /<Output logstash_infrastructure>/
      })
    }

    it { should contain_file('c:\nxlog\conf\nxlog.conf').with({
      :content => /
<Output logstash_eventlog>
    Module        om_tcp
    Host          logstash
    Port          1935
<\/Output>
/
      })
    }
  end

  describe 'nxlog eventlog defined without logging host' do
    let(:params) {{
      :service_enabled => true,
      :install_dir     => 'c:\nxlog',
      :logging_config  => {
        'eventlog' => {
          'port' => '1935',
        },
      },
    }}

    it do
      expect { should compile }.to raise_error(Puppet::Error, /eventlog logging host cannot be nil or empty/)
    end
  end

  describe 'nxlog eventlog defined without logging port' do
    let(:params) {{
      :service_enabled => true,
      :install_dir     => 'c:\nxlog',
      :logging_config  => {
        'eventlog' => {
          'host' => 'logstash',
        },
      },
    }}

    it do
      expect { should compile }.to raise_error(Puppet::Error, /eventlog logging port cannot be nil or empty/)
    end
  end

  describe 'nxlog infrastructure only configuration generation' do
    let(:params) {{
      :service_enabled => true,
      :install_dir     => 'c:\nxlog',
      :logging_config  => {
        'infrastructure' => {
          'host'   => 'logstash',
          'port'   => '1937',
        },
      },
    }}

    it { should contain_file('c:\nxlog\conf\nxlog.conf').without({
        :content => /<Output logstash_iis>/,
      }).without({
        :content => /<Input eventlog>/
      }).with({
        :content => /<Output logstash_infrastructure>/
      }).with(
        :content => /
<Output logstash_infrastructure>
    Module        om_tcp
    Host          logstash
    Port          1937
<\/Output>
/
    )}
  end

  describe 'nxlog infrastructure defined without logging host' do
    let(:params) {{
      :service_enabled => true,
      :install_dir     => 'c:\nxlog',
      :logging_config  => {
        'infrastructure' => {
          'port' => '1937',
        },
      },
    }}

    it do
      expect { should compile }.to raise_error(Puppet::Error, /infrastructure logging host cannot be nil or empty/)
    end
  end

  describe 'nxlog infrastructure defined without logging port' do
    let(:params) {{
      :service_enabled => true,
      :install_dir     => 'c:\nxlog',
      :logging_config  => {
        'infrastructure' => {
          'host' => 'logstash',
        },
      },
    }}

    it do
      expect { should compile }.to raise_error(Puppet::Error, /infrastructure logging port cannot be nil or empty/)
    end
  end

  describe 'nxlog all configurations included' do
    let(:params) {{
      :service_enabled => true,
      :install_dir     => 'c:\nxlog',
      :logging_config  => {
        'iis' => {
          'host'   => 'logstash',
          'port'   => '1938',
          'fields' => 'date time s-sitename s-computername s-ip cs-method cs-uri-stem cs-uri-query s-port cs-username c-ip cs-version cs(User-Agent) cs(Cookie) cs(Referer) cs-host sc-status sc-substatus sc-win32-status sc-bytes cs-bytes time-taken',
        },
        'eventlog' => {
          'host'   => 'logstash',
          'port'   => '1935',
        },
        'infrastructure' => {
          'host'   => 'logstash',
          'port'   => '1937',
        },
      }
    }}

    it { should contain_file('c:\nxlog\conf\nxlog.conf').with({
        :content => /
    Fields        \$date, \$time, \$service, \$server_name, \$host, \$http_method, \$http_path, \$http_querystring, \$server_port, \$http_username, \$client_ip, \$http_version, \$http_useragent, \$http_cookie, \$http_referer, \$http_host, \$http_status_code, \$http_sub_status_code, \$win32_status_code, \$bytes_sent, \$bytes_received, \$duration
    FieldTypes    string, string, string, string, string, string, string, string, integer, string, string, string, string, string, string, string, integer, integer, integer, integer, integer, integer
/,
      }).with({
        :content => /
<Output logstash_iis>
    Module        om_tcp
    Host          logstash
    Port          1938
<\/Output>
/
      }).with({
        :content => /
<Output logstash_eventlog>
    Module        om_tcp
    Host          logstash
    Port          1935
<\/Output>
/
      }).with({
        :content => /
<Output logstash_infrastructure>
    Module        om_tcp
    Host          logstash
    Port          1937
<\/Output>
/
      })
    }
  end
end
