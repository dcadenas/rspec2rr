$: << File.expand_path(File.join(File.dirname(__FILE__), '../..'))

require 'rubygems'
require 'spec'
require 'lib/rspec2rr'
require 'filetesthelper'

include FileTestHelper

def spec_file_content
  <<-SPECFILECONTENT
    a_string = 'this line is here just to represent a line that should not be changed by rspec2rr'

    a.stub!(:asdf).with(1234)
    b.stub!(:asdf)
    b.should_not_receive(:asdf).with(1234)
    b.should_not_receive(:asdf)
    AModule::AClass.should_receive(:asdf).with(1234)
    AModule::AClass.should_receive(:asdf)

    a_string = 'this line is here just to represent a line that should not be changed by rspec2rr'
    a_string = 'this line is here just to represent a line that should not be changed by rspec2rr'
  SPECFILECONTENT
end

def expected_spec_file_content
  <<-EXPECTEDSPECFILECONTENT
    a_string = 'this line is here just to represent a line that should not be changed by rspec2rr'

    stub(a).asdf(1234)
    stub(b).asdf
    dont_allow(b).asdf(1234)
    dont_allow(b).asdf
    mock(AModule::AClass).asdf(1234)
    mock(AModule::AClass).asdf

    a_string = 'this line is here just to represent a line that should not be changed by rspec2rr'
    a_string = 'this line is here just to represent a line that should not be changed by rspec2rr'
  EXPECTEDSPECFILECONTENT
end

TOOLPATH = File.expand_path(File.join(File.dirname(__FILE__), '..' , '..', 'bin' , 'rspec2rr'))

def run_rspec2rr
  `#{TOOLPATH}`
end

describe "rspec2rr" do
  it "should convert a spec file rrspec doubles to rr syntax" do
    with_files 'spec/test_spec.rb' => spec_file_content do
      run_rspec2rr
      changed_spec_file_content = File.read 'spec/test_spec.rb'
      changed_spec_file_content.should == expected_spec_file_content
    end
  end

  it "should not convert a spec file if it is not located in the spec dir" do
    with_files 'a_dir/test_spec.rb' => spec_file_content do
      run_rspec2rr
      changed_spec_file_content = File.read 'a_dir/test_spec.rb'
      changed_spec_file_content.should_not == expected_spec_file_content
    end
  end

  it "should not convert rb files that are not specs" do
    with_files 'spec/only_specs_should_change_so_this_file_shouldnt_change.rb' => 'AModule.stub!(:method_name)' do
      run_rspec2rr
      unaltered_file_content = File.read 'spec/only_specs_should_change_so_this_file_shouldnt_change.rb'
      unaltered_file_content.should == 'AModule.stub!(:method_name)'
    end
  end
end
