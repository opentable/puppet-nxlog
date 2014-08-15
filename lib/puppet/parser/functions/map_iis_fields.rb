module Puppet::Parser::Functions
  newfunction(:map_iis_fields, :type => :rvalue) do |args|

    if args.length != 1
      raise Puppet::ParseError, ("map_iis_fields(): wrong number of args (#{args.length}; must be 1)")
    end

    nxlog_fieldlist = Array.new

    args[0].strip.split(' ').each do |iis_field|
      case iis_field
        when 'time'
          nxlog_fieldlist.push('$time')
        when 'date'
          nxlog_fieldlist.push('$date')
        when 's-sitename'
          nxlog_fieldlist.push('$service')
        when 's-computername'
          nxlog_fieldlist.push('$server_name')
        when 's-ip'
          nxlog_fieldlist.push('$host')
        when 'cs-method'
          nxlog_fieldlist.push('$http_method')
        when 'cs-uri-stem'
          nxlog_fieldlist.push('$http_path')
        when 'cs-uri-query'
          nxlog_fieldlist.push('$http_querystring')
        when 's-port'
          nxlog_fieldlist.push('$server_port')
        when 'cs-username'
          nxlog_fieldlist.push('$http_username')
        when 'c-ip'
          nxlog_fieldlist.push('$client_ip')
        when 'cs-version'
          nxlog_fieldlist.push('$http_version')
        when 'cs(User-Agent)'
          nxlog_fieldlist.push('$http_useragent')
        when 'cs(Cookie)'
          nxlog_fieldlist.push('$http_cookie')
        when 'cs(Referer)'
          nxlog_fieldlist.push('$http_referer')
        when 'cs-host'
          nxlog_fieldlist.push('$http_host')
        when 'sc-status'
          nxlog_fieldlist.push('$http_status_code')
        when 'sc-substatus'
          nxlog_fieldlist.push('$http_sub_status_code')
        when 'sc-win32-status'
          nxlog_fieldlist.push('$win32_status_code')
        when 'sc-bytes'
          nxlog_fieldlist.push('$bytes_sent')
        when 'cs-bytes'
          nxlog_fieldlist.push('$bytes_received')
        when 'time-taken'
          nxlog_fieldlist.push('$duration')
      end
    end

    nxlog_fieldlist.join(', ')
  end
end
