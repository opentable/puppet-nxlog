require 'rexml/document'

# A module/static class for parsing site names in a well-behaved manner
module SiteNames
  class << self
    # All names that will be present in the hash map from #parse.
    ALL_NAMES = %w|name version build maj min patch comment|.map { |s| :"#{s}" }

    # All the names from 'ALL_NAMES' that will be ints if present or nil otherwise.
    INT_NAMES = %w|maj min patch|.map { |s| :"#{s}" }

    # The regex that is being used to match a site name into a hash of more semantic
    # data.
    SITE_REGEX = /^
(?<name> [a-zA-Z\s_-]+)$ # either single name only, no digits
# of a compound name, no spaces, with digits
| (?<name> [a-zA-Z\d_-]+)$
# or all of the below:
| (?<name> [\w\s]+) [\s_] 
[vV]? # having 'v' in front of version is optional
(?<version>
  # either we have an opaque build no at the end
  (?<build> \d+$)
  # or we have M.m.p format
  | ((?<maj> \d+)\.
     (?<min> \d+) 
     (\.(?<patch> \d+))? )
)? # all of version if optional
# allow some number of spaces before matching comment
\s* (?<comment> \w [\w\s-]+)?
$/x

    # Parse the site_name into hash with 
    def parse site_name
      raise ArgumentError, 'missing site_name parameter' unless site_name
      match_data = SITE_REGEX.match site_name
      raise ArgumentError, "couldn't parse #{site_name.inspect}" if match_data.nil?

      data = { :raw => site_name }

      # convert maj, min, patch to ints
      INT_NAMES.
        map { |sym| [sym, int(match_data[sym])] }.
        each { |sym, val| data[sym] = val }

      # return the rest in the Data hash
      (ALL_NAMES - INT_NAMES).each { |sym| data[sym] = match_data[sym] }

      # include the lowercase normalised name
      data[:lowercase_name] = lowercase_name site_name
      data
    end

    def parse_site_xml xml_str, replacements = {}
      raise ArgumentError, 'xml_str is nil' unless xml_str
      raise ArgumentError, 'replacements is nil' unless replacements

      doc = REXML::Document.new xml_str
      base_log_path = REXML::XPath.first(doc,'//siteDefaults/logFile/@directory').to_s
      base_log_path = fixpoint base_log_path, replacements

      sites = []
      doc.elements.each('//site') do |s|
        sites <<
          { :name           => s.attributes['name'],
            :lowercase_name => lowercase_name(s.attributes['name']),
            :id             => s.attributes['id'],
            :base_log_path  => base_log_path }
      end
      sites
    end

    def lowercase_name original
      original.gsub(/-/,'_').gsub(/\s/, '_').downcase
    end

    private
    def fixpoint str, replacements, prev = nil
      # puts "(1) fixpoint #{str.inspect}, #{replacements.inspect}, #{prev.inspect}"
      return str if str.nil? or str == prev or str === /^\s*$/x
      nxt = replacements.inject str do |s, t|
        repl, with = t
        s.gsub repl, with
      end
      # puts "(3) fixpoint #{nxt.inspect}, #{replacements.inspect}, #{str.inspect}"
      fixpoint nxt, replacements, str
    end

    def int s
      case s
      when /^\d+$/
        s.to_i
      else
        nil
      end
    end
  end
end

