module Puppet::Parser::Functions
  newfunction(:map_iis_fieldtypes, :type => :rvalue) do |args|

    if args.length != 1
      raise Puppet::ParseError, ("map_iis_fieldtypes(): wrong number of args (#{args.length}; must be 1)")
    end

    nxlog_fieldtypeslist = Array.new

    args[0].strip.split(' ').each do |iis_field|
      case iis_field
        when 's-port','sc-status','sc-substatus','sc-win32-status','sc-bytes','cs-bytes','time-taken'
          nxlog_fieldtypeslist.push('integer')
        else
          nxlog_fieldtypeslist.push('string')
      end
    end

    nxlog_fieldtypeslist.join(', ')
  end
end
