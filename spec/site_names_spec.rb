require 'facter/site_names'

{ 'MyApp v1.2.3 With a Comment - v23' =>
  { :name    => 'MyApp',
    :version => '1.2.3',
    :build   => nil,
    :maj     => 1,
    :min     => 2,
    :patch   => 3,
    :comment => 'With a Comment - v23' },
  'MyApp 1.2.3' =>
  { :name    => 'MyApp',
    :version => '1.2.3',
    :build   => nil,
    :maj     => 1,
    :min     => 2,
    :patch   => 3,
    :comment => nil },
  'Front 1234' =>
  { :name    => 'Front',
    :version => '1234',
    :build   => '1234',
    :maj     => nil,
    :min     => nil,
    :patch   => nil,
    :comment => nil },
  'First App 1.2.3' =>
  { :name    => 'First App',
    :version => '1.2.3',
    :build   => nil,
    :maj     => 1,
    :min     => 2,
    :patch   => 3,
    :comment => nil },
  'Front 3.4 Is Awesome' =>
  { :name    => 'Front',
    :version => '3.4',
    :build   => nil,
    :maj     => 3,
    :min     => 4,
    :patch   => nil,
    :comment => 'Is Awesome' },
  'Just a name' =>
  { :name    => 'Just a name',
    :version => nil,
    :build   => nil,
    :maj     => nil,
    :min     => nil,
    :patch   => nil,
    :comment => nil },
  'Just_a_name' =>
  { :name    => 'Just_a_name',
    :version => nil,
    :build   => nil,
    :maj     => nil,
    :min     => nil,
    :patch   => nil,
    :comment => nil },
  'Just_a_name_v1.2.3' =>
  { :name    => 'Just_a_name',
    :version => '1.2.3',
    :build   => nil,
    :maj     => 1,
    :min     => 2,
    :patch   => 3,
    :comment => nil },
  'Just_a_name123' =>
  { :name    => 'Just_a_name123',
    :version => nil,
    :build   => nil,
    :maj     => nil,
    :min     => nil,
    :patch   => nil,
    :comment => nil },
}.each do |name, exp|
  describe SiteNames, "when using regex on #{name.inspect}" do
    subject do
      SiteNames.parse name
    end
    exp.each do |k, v|
      it "should parse #{k.inspect} to #{exp[k].inspect || 'nil'}" do
        subject[k].should eq(exp[k])
      end
    end
  end
end

describe SiteNames, 'when getting facter compatible data' do
  let :xml_sample do
    File.read(File.expand_path('../data/sites.xml', __FILE__))
  end

  subject do
    SiteNames.parse_site_xml xml_sample
  end

  it 'should return something enumerable' do
    should respond_to :each
  end

  %w|name lowercase_name id base_log_path|.map { |s| :"#{s}" }.each do |sym|
    it "should have symbol #{sym.inspect} in hash of first" do
      subject.first.should_not be_nil
      subject.first[sym].should_not be_nil
    end
  end
end

describe SiteNames, '#fixpoint' do
  subject do
    lambda { |str, repl| SiteNames.send(:fixpoint, str, repl) }
  end

  it 'should replace single pattern' do
    subject.call('a b c', { 'a' => 'x' }).should eq('x b c')
  end
end
