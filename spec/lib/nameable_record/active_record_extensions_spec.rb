require 'spec_helper'
require 'rails_spec_helper'

describe NameableRecord::ActiveRecordExtensions do

  let :user do
    User.new
  end

  let :name do
    NameableRecord::Name.new *name_parts
  end

  context 'setting the composed of fields from a NameableRecord::Name instance' do

    before :each do
      user.name = name
    end

    it '#name_last' do
      user.name_last.should == 'Smith'
    end

    it '#name_first' do
      user.name_first.should == 'John'
    end

    it '#name_middle' do
      user.name_middle.should == 'Jacob'
    end

    it '#name_prefix' do
      user.name_prefix.should == 'Mr.'
    end

    it '#name_suffix' do
      user.name_suffix.should == 'III'
    end

  end

end

