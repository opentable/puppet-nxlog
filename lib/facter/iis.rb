begin
  if Facter.value('operatingsystem') == 'windows'
    require 'rexml/document'
    xml = Facter::Util::Resolution.exec("#{ENV['SystemRoot']}\\system32\\inetsrv\\appcmd.exe list config -section:sites")
    doc = REXML::Document.new xml
    sites = []
    doc.elements.each('//site') {|s| sites << {:name => s.attributes['name'].gsub(/\s/,'_').downcase, :id => s.attributes['id']}}
    base_log_path = REXML::XPath.first(doc,'//siteDefaults/logFile/@directory').to_s.gsub('%','').gsub(/SystemDrive/) {|v|ENV[v]}

    Facter.add("iis_sites") do
      setcode do
        sites.map{|s| s[:name]}.join(',')
      end
    end

    sites.each do |site|
      Facter.add("iis_#{site[:name]}_logdir") do
        setcode do
          "#{base_log_path}\\w3svc#{site[:id]}"
        end
      end
    end
  end
rescue Exception => e
  puts "Something went wrong in iis fact:"
  puts e.message
  puts e.backtrace.inspect
end
