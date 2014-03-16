require 'facter/site_names'

module Iis
  module SiteStanza
    class << self
      def generate meta, scope
        raise ArgumentError, 'meta is nil' if meta.nil?
        indent = "                    "
        %{<Input #{meta[:lowercase_name]}> 
    Module          im_file 
    File            '#{ scope["::iis_#{meta[:lowercase_name]}_logdir"] }\\*.log'
    ReadFromLast    TRUE
    Exec            if (($raw_event =~ /^#/) or ($raw_event =~ /^$/)) drop(); \\
                    else w3c->parse_csv(); \\
                    #{write_meta indent, meta}
</Input>}
      end

      private
      def prop_name k, v
        case k
        when :name
          %{$service = "#{v}";}
        when :version
          %{$service_version = "v#{v}";}
        when :build
          %{$service_version_build = "#{v}";}
        when :maj
          %{$service_version_maj = "#{v}";}
        when :min
          %{$service_version_min = "#{v}";}
        when :patch
          %{$service_version_patch = "#{v}";}
        when :comment
          %{$service_comment = "#{v}";}
        end
      end

      def write_meta indent, meta
        meta.
          reject { |_, v| v.nil? or (v.respond_to? :empty? and v.empty?) }.
          map { |k, v| prop_name k, v }.
          reject { |x| x.nil? }.
          inject { |s, t| "#{s} \\\n#{indent}#{t}" }
      end
    end
  end
end
