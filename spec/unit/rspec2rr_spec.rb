$: << File.expand_path(File.join(File.dirname(__FILE__), '../..'))

require 'rubygems'
require 'spec'
require 'lib/rspec2rr'

def more_lines string = ''
  <<-FAKEFILE
    asd.asdf.asdfadsf
    #{string}
    asfd.asdf.asdf

  FAKEFILE
end

def assert_converts actual, expected
  RSpec2RR.to_rr(more_lines(actual)).should == more_lines(expected)
end

describe 'rspec2rr' do
  it 'should not change a nil string' do
    RSpec2RR.to_rr(nil).should == nil
  end

  it 'should not change an empty string' do
    RSpec2RR.to_rr('').should == ''
  end

  it 'should not change a string with no rspec mocks' do
    RSpec2RR.to_rr(more_lines).should == more_lines
  end

  it 'should convert stub!(:method_name) to rr syntax' do
    rspec_mock_string = 'A::Class.stub!(:stubbed_method)'

    assert_converts rspec_mock_string, 'stub(A::Class).stubbed_method'
  end

  it 'should convert should_receive(:method_name) to rr syntax' do
    rspec_mock_string = 'A::Class.should_receive(:stubbed_method)'

    assert_converts rspec_mock_string, 'mock(A::Class).stubbed_method'
  end

  it 'should convert stub!(:method_name).with(something) to rr syntax' do
    rspec_mock_string = 'A::Class.stub!(:stubbed_method).with(something)'

    assert_converts rspec_mock_string, 'stub(A::Class).stubbed_method(something)'
  end

  it 'should convert should_receive(:method_name).with(something) to rr syntax' do
    rspec_mock_string = 'A::Class.should_receive(:stubbed_method).with(something)'

    assert_converts rspec_mock_string, 'mock(A::Class).stubbed_method(something)'
  end

  it 'should convert should_not_receive(:method_name).with(something) to rr syntax' do
    rspec_mock_string = 'A::Class.should_not_receive(:stubbed_method).with(something)'

    assert_converts rspec_mock_string, 'dont_allow(A::Class).stubbed_method(something)'
  end

  it 'should convert and_return to block' do
    rspec_mock_string = 'User.stub!(:find_by_email).and_return(@user)'

    assert_converts rspec_mock_string, 'stub(User).find_by_email {@user}'
  end
end



