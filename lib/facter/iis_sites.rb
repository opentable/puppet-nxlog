require 'facter'
require 'facter/site_names'

begin
  return unless Facter.value('operatingsystem') == 'windows'

  xml = Facter::Util::Resolution.exec "#{ENV['SystemRoot']}\\system32\\inetsrv\\appcmd.exe list config -section:sites"

  sites = SiteNames.parse_xml xml

  # set first fact
  Facter.add 'iis_sites' do
    setcode do
      sites.map { |s| s[:name] }.join(',')
    end
  end

  # set fact per-site
  sites.each do |site|
    Facter.add "iis_#{site[:lowercase_name]}_logdir" do
      setcode do
        "#{site[:base_log_path]}\\w3svc#{site[:id]}"
      end
    end
  end
rescue Exception => e
  puts "Something went wrong in iis fact:"
  puts e.message
  puts e.backtrace.inspect
end
