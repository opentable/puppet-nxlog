require 'erb'

class Namespace
  def initialize hash
    hash.each do |key, value|
      singleton_class.send(:instance_variable_set, "@#{key}", value) unless key.include? '::'
      #singleton_class.send(:define_method, key) { value } unless key.include? '::'
    end
    singleton_class.send(:define_method, :scope) { hash }
  end

  def get_binding
    binding
  end
end

describe 'the generated config' do
  let :template do
    File.read(File.expand_path('../../templates/nxlog.conf.erb', __FILE__))
  end

  let :scope do
    { '::iis_sites' => 'SiteName v1.2.3 with Comment,s2,s3',
      '::iis_sitename_v1.2.3_with_comment_logdir' => 'D:\\Logs\\',
      '::iis_s2_logdir' => 'D:\\Logs\\',
      '::iis_s3_logdir' => 'D:\\Logs\\',
      'install_dir'     => 'C:\\inetpub\\' }
  end

  def render ns_vals
    namespace = Namespace.new ns_vals
    ERB.new(template).result(namespace.instance_eval { binding })
  end

  it 'should contain an <Input sitename_v1.2.3_with_comment>' do
    render(scope).should include('<Input sitename_v1.2.3_with_comment>')
  end
  it 'should contain an <Input s2>' do
    render(scope).should include('<Input s2>')
  end
  it 'should contain an <Input s3>' do
    render(scope).should include('<Input s3>')
  end
end

