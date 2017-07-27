require 'spec_helper'
describe 'tecasplunk' do
  context 'with default values for all parameters' do
    it { should contain_class('tecasplunk') }
  end
end
