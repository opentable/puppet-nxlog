require 'spec_helper'

describe 'map_iis_fieldtypes', :type => :function do
  describe 'generates fieldtypes list for nxlog iis fieldtypes declaration from an iis logfiles Fields row' do
    it {
      should run.with_params('date time s-ip cs-method cs-uri-stem cs-uri-query s-port cs-username c-ip cs(User-Agent) sc-status sc-substatus sc-win32-status time-taken')
        .and_return('string, string, string, string, string, string, integer, string, string, string, integer, integer, integer, integer') }
  end

  describe 'date field maps correct fieldtype' do
    it { should run.with_params('date').and_return('string') }
  end

  describe 'time field maps correct fieldtype' do
    it { should run.with_params('time').and_return('string') }
  end

  describe 's-sitename field maps correct fieldtype' do
    it { should run.with_params('s-sitename').and_return('string') }
  end

  describe 's-computername field maps correct fieldtype' do
    it { should run.with_params('s-computername').and_return('string') }
  end

  describe 'c-ip field maps correct fieldtype' do
    it { should run.with_params('c-ip').and_return('string') }
  end

  describe 'cs-method field maps correct fieldtype' do
    it { should run.with_params('cs-method').and_return('string') }
  end

  describe 'cs-uri-stem field maps correct fieldtype' do
    it { should run.with_params('cs-uri-stem').and_return('string') }
  end

  describe 'cs-uri-query field maps correct fieldtype' do
    it { should run.with_params('cs-uri-query').and_return('string') }
  end

  describe 's-port field maps correct fieldtype' do
    it { should run.with_params('s-port').and_return('integer') }
  end

  describe 's-username field maps correct fieldtype' do
    it { should run.with_params('cs-username').and_return('string') }
  end

  describe 'c-ip field maps correct fieldtype' do
    it { should run.with_params('c-ip').and_return('string') }
  end

  describe 'cs-version field maps correct fieldtype' do
    it { should run.with_params('cs-version').and_return('string') }
  end

  describe 'cs(User-Agent) field maps correct fieldtype' do
    it { should run.with_params('cs(User-Agent)').and_return('string') }
  end

  describe 'cs(Cookie) field maps correct fieldtype' do
    it { should run.with_params('cs(Cookie)').and_return('string') }
  end

  describe 'cs(Referer) field maps correct fieldtype' do
    it { should run.with_params('cs(Referer)').and_return('string') }
  end

  describe 'cs-host field maps correct fieldtype' do
    it { should run.with_params('cs-host').and_return('string') }
  end

  describe 'sc-status field maps correct fieldtype' do
    it { should run.with_params('sc-status').and_return('integer') }
  end

  describe 'sc-substatus field maps correct fieldtype' do
    it { should run.with_params('sc-substatus').and_return('integer') }
  end

  describe 'sc-win32-status field maps correct fieldtype' do
    it { should run.with_params('sc-win32-status').and_return('integer') }
  end

  describe 'sc-bytes field maps correct fieldtype' do
    it { should run.with_params('sc-bytes').and_return('integer') }
  end

  describe 'cs-bytes field maps correct fieldtype' do
    it { should run.with_params('cs-bytes').and_return('integer') }
  end

  describe 'time-taken field maps correct fieldtype' do
    it { should run.with_params('time-taken').and_return('integer') }
  end
end
