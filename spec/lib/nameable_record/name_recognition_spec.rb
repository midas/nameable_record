require 'spec_helper'
require File.expand_path( "#{File.dirname __FILE__}/name_recognition_sharedspec" )

describe NameableRecord::NameRecognition do

  class SomeClass
    include NameableRecord::NameRecognition
  end

  let :recognition_instance do
    SomeClass.new
  end

  it_should_behave_like 'any name recognition'

end

