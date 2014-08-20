require 'spec_helper'

describe 'map_iis_fields', :type => :function do
  describe 'generates graphite namespace with correct input arguments' do
    it {
      should run.with_params('date time s-sitename s-computername s-ip cs-method cs-uri-stem cs-uri-query s-port cs-username c-ip cs-version cs(User-Agent) cs(Cookie) cs(Referer) cs-host sc-status sc-substatus sc-win32-status sc-bytes cs-bytes time-taken')
        .and_return('$date, $time, $service, $server_name, $host, $http_method, $http_path, $http_querystring, $server_port, $http_username, $client_ip, $http_version, $http_useragent, $http_cookie, $http_referer, $http_host, $http_status_code, $http_sub_status_code, $win32_status_code, $bytes_sent, $bytes_received, $duration') }
  end

  describe 'generates $param list for nxlog iis fields declaration from an iis logfiles Fields row' do
    it {
      should run.with_params('date time s-ip cs-method cs-uri-stem cs-uri-query s-port cs-username c-ip cs(User-Agent) sc-status sc-substatus sc-win32-status time-taken')
        .and_return('$date, $time, $host, $http_method, $http_path, $http_querystring, $server_port, $http_username, $client_ip, $http_useragent, $http_status_code, $http_sub_status_code, $win32_status_code, $duration') }
  end
end
