require 'spec_helper'

describe NameableRecord::Name do

  subject { name }

  let :name do
    described_class.new *name_parts
  end

  let :another_name do
    described_class.new *name_parts
  end

  it 'should be frozen after initialization' do
    subject.should be_frozen
  end

  it 'should know when it is equal to another Name' do
    subject.eql?( another_name ).should be_true
    subject.==( another_name ).should be_true
  end

  context 'PREDEFINED_PATTERNS' do

    subject { described_class::PREDEFINED_PATTERNS }

    it { should == {
          :full => "%l, %f %s",
          :full_with_middle => "%l, %f %m %s",
          :full_with_prefix => "%l, %p %f %s",
          :full_sentence => "%p %f %l %s",
          :full_sentence_with_middle => "%p %f %m %l %s"
       }
    }

  end

  context 'PATTERN_MAP' do

    subject { described_class::PATTERN_MAP }

    it { should == {
           /%l/ => :last,
           /%f/ => :first,
           /%m/ => :middle,
           /%p/ => :prefix,
           /%s/ => :suffix
       }
    }

  end

  context 'PREFIX_BASE' do

    subject { described_class::PREFIX_BASE.sort }

    it { should == %w(Mr Mrs Miss Dr).sort }

  end

  context 'SUFFIX_BASE' do

    subject { described_class::SUFFIX_BASE.sort }

    it { should == %w(Jr III IV V Esq).sort }

  end

  context 'PREFIXES' do

    subject { described_class::PREFIXES }

    it { should == ["DR", "DR.", "Dr", "Dr.", "MISS", "MISS.", "MR", "MR.", "MRS", "MRS.", "Miss", "Miss.", "Mr", "Mr.", "Mrs", "Mrs.", "dr", "dr.", "miss", "miss.", "mr", "mr.", "mrs", "mrs."] }

  end

  context 'SUFFIXES' do

    subject { described_class::SUFFIXES }

    it { should == ["ESQ", "ESQ.", "Esq", "Esq.", "III", "III", "III.", "III.", "IV", "IV", "IV.", "IV.", "JR", "JR.", "Jr", "Jr.", "V", "V", "V.", "V.", "esq", "esq.", "iii", "iii.", "iv", "iv.", "jr", "jr.", "v", "v."] }

  end

  context 'PREFIXES_CORRECTIONS' do

    subject { described_class::PREFIXES_CORRECTIONS }

    it { should == {
           "dr."   => "Dr",
           "Dr."   => "Dr",
           "DR."   => "Dr",
           "dr"    => "Dr",
           "Dr"    => "Dr",
           "DR"    => "Dr",
           "mrs."  => "Mrs",
           "Mrs."  => "Mrs",
           "MRS."  => "Mrs",
           "mrs"   => "Mrs",
           "Mrs"   => "Mrs",
           "MRS"   => "Mrs",
           "miss"  => "Miss",
           "Miss"  => "Miss",
           "MISS"  => "Miss",
           "miss." => "Miss",
           "Miss." => "Miss",
           "MISS." => "Miss",
           "mr."   => "Mr",
           "Mr."   => "Mr",
           "mr"    => "Mr",
           "Mr"    => "Mr",
           "MR"    => "Mr",
           "MR."   => "Mr"
       }
    }

  end

  context 'SUFFIXES_CORRECTIONS' do

    subject { described_class::SUFFIXES_CORRECTIONS }

    it { should == {
           "jr"   => "Jr",
           "jr."  => "Jr",
           "Jr."  => "Jr",
           "JR."  => "Jr",
           "Jr"   => "Jr",
           "JR"   => "Jr",
           "iii." => "III",
           "III." => "III",
           "iii"  => "III",
           "III"  => "III",
           "IV."  => "IV",
           "iv"   => "IV",
           "iv."  => "IV",
           "IV"   => "IV",
           "v."   => "V",
           "V"    => "V",
           "v"    => "V",
           "V."   => "V",
           "esq"  => "Esq",
           "esq." => "Esq",
           "ESQ." => "Esq",
           "Esq"  => "Esq",
           "ESQ"  => "Esq",
           "Esq." => "Esq"
       }
    }

  end

  context '#to_s' do

    subject { name.to_s }

    it { should == 'Smith, John' }

    context 'when given a default pattern' do

      context ':full' do

        subject { name.to_s :full }

        it { should == 'Smith, John III' }

      end

      context ':full' do

        subject { name.to_s :full_with_middle }

        it { should == 'Smith, John Jacob III' }

      end

      context ':full' do

        subject { name.to_s :full_with_prefix }

        it { should == 'Smith, Mr. John III' }

      end

      context ':full' do

        subject { name.to_s :full_sentence }

        it { should == 'Mr. John Smith III' }

      end

      context ':full' do

        subject { name.to_s :full_sentence_with_middle }

        it { should == 'Mr. John Jacob Smith III' }

      end

    end

    context 'when given a pattern' do

      context "'%f %l'" do

        subject { name.to_s '%f %l' }

        it { should == 'John Smith' }

      end

      context "'%p %f %l'" do

        subject { name.to_s '%p %f %l' }

        it { should == 'Mr. John Smith' }

      end

      context "'%p %f %l %s'" do

        subject { name.to_s '%p %f %l %s' }

        it { should == 'Mr. John Smith III' }

      end

      context "'%p %f %m %l %s'" do

        subject { name.to_s '%p %f %m %l %s' }

        it { should == 'Mr. John Jacob Smith III' }

      end

    end

  end

  # context 'parsing' do

  #   context 'a string name' do

  #     context 'John Smith' do

  #       subject { described_class.parse( 'John Smith' ) }

  #       it { should == described_class.new( 'Smith', 'John' ) }

  #     end

  #     context 'John Jacob Smith' do

  #       subject { described_class.parse( 'John Jacob Smith' ) }

  #       it { should == described_class.new( 'Smith', 'John', nil, 'Jacob' ) }

  #     end

  #     context 'Mr. John Smith' do

  #       subject { described_class.parse( 'Mr. John Smith' ) }

  #       it { should == described_class.new( 'Smith', 'John', 'Mr.' ) }

  #     end

  #     context 'Mr. John Jacob Smith' do

  #       subject { described_class.parse( 'Mr. John Jacob Smith' ) }

  #       it { should == described_class.new( 'Smith', 'John', 'Mr.', 'Jacob' ) }

  #     end

  #     context 'John Jacob Smith Jr.' do

  #       subject { described_class.parse( 'John Jacob Smith Jr.' ) }

  #       it { should == described_class.new( 'Smith', 'John', nil, 'Jacob', 'Jr' ) }

  #     end

  #     context 'Mr. John Smith Jr' do

  #       subject { described_class.parse( 'Mr. John Smith Jr' ) }

  #       it { should == described_class.new( 'Smith', 'John', 'Mr.', nil, 'Jr' ) }

  #     end

  #     context 'Mr John Jacob Smith III' do

  #       subject { described_class.parse( 'Mr John Jacob Smith III' ) }

  #       it { should == described_class.new( 'Smith', 'John', 'Mr.', 'Jacob', 'III' ) }

  #     end

  #   end

  # end

end

