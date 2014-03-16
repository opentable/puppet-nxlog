require 'iis/site_stanza'

shared_context 'metadata' do
  let :metadata do
    SiteNames.parse "My App v1.2.3 With a Comment - v23"
  end
  let :scope do
    { "::iis_#{metadata[:lowecase_name]}_logdir" => %|C:\\Logs\\| }
  end
  subject do
    Iis::SiteStanza.generate metadata, scope
  end
end

describe 'generation of service stanza' do
  include_context 'metadata'

  it 'can generate $service' do
    subject.should include('$service = "My App";')
  end

  it 'can generate $service_version' do
    subject.should include('$service_version = "v1.2.3"; \\')
  end

  it 'can generate $service_comment' do
    # last part of stanza
    subject.should include('$service_comment = "With a Comment - v23";')
  end
end
