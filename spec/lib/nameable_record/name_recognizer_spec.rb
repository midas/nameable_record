require 'spec_helper'
require File.expand_path( "#{File.dirname __FILE__}/name_recognition_sharedspec" )

describe NameableRecord::NameRecognizer do

  let :recognition_instance do
    described_class.new
  end

  it 'should include the NameRecognition module' do
    described_class.should include NameableRecord::NameRecognition
  end

  it_should_behave_like 'any name recognition'

end

