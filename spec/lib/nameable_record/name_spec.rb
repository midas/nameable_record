require 'spec_helper'

describe NameableRecord::Name do

  context 'parsing' do

    context 'a string name' do

      context 'John Smith' do

        subject { described_class.parse( 'John Smith' ) }

        it { should == described_class.new( 'Smith', 'John' ) }

      end

      context 'John Jacob Smith' do

        subject { described_class.parse( 'John Jacob Smith' ) }

        it { should == described_class.new( 'Smith', 'John', nil, 'Jacob' ) }

      end

      context 'Mr. John Smith' do

        subject { described_class.parse( 'Mr. John Smith' ) }

        it { should == described_class.new( 'Smith', 'John', 'Mr.' ) }

      end

      context 'Mr. John Jacob Smith' do

        subject { described_class.parse( 'Mr. John Jacob Smith' ) }

        it { should == described_class.new( 'Smith', 'John', 'Mr.', 'Jacob' ) }

      end

      context 'John Jacob Smith Jr.' do

        subject { described_class.parse( 'John Jacob Smith Jr.' ) }

        it { should == described_class.new( 'Smith', 'John', nil, 'Jacob', 'Jr' ) }

      end

      context 'Mr. John Smith Jr' do

        subject { described_class.parse( 'Mr. John Smith Jr' ) }

        it { should == described_class.new( 'Smith', 'John', 'Mr.', nil, 'Jr' ) }

      end

      context 'Mr John Jacob Smith III' do

        subject { described_class.parse( 'Mr John Jacob Smith III' ) }

        it { should == described_class.new( 'Smith', 'John', 'Mr.', 'Jacob', 'III' ) }

      end

    end

  end

end

