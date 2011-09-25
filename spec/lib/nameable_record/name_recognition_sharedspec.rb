require 'spec_helper'

shared_examples_for 'any name recognition' do

  context '#surnames' do

    subject { recognition_instance.surnames.size }

    it { should == 9527 }

  end

  context '#surnames_all_downcase' do

    subject { recognition_instance.surnames_all_downcase.first }

    it { should == 'aaron' }

  end

  context '#surnames_all_upcase' do

    subject { recognition_instance.surnames_all_upcase.first }

    it { should == 'AARON' }

  end

  context '#human_name?' do

    context 'when the name matches the pattern {last name} {first initial}{middle initial}' do

      subject { recognition_instance.human_name?( 'HOMER SA' ) }

      it { should be_true }

    end

    context 'when the name matches the pattern {first initial}{middle initial} {last name}' do

      subject { recognition_instance.human_name?( 'SA HOMER' ) }

      it { should be_true }

    end

    context 'when the middle initial has no .' do

      subject { recognition_instance.human_name?( 'HOMER STEPHEN A' ) }

      it { should be_true }

    end

    context 'when the middle initial has a .' do

      subject { recognition_instance.human_name?( 'HOMER STEPHEN A.' ) }

      it { should be_true }

    end

    context 'when the name is an 80% match' do

      subject { recognition_instance.human_name?( 'CUP STEPHEN A' ) }

      it { should be_false }

    end

    context 'when the name is less an 80% match with a 70% threshold' do

      subject { recognition_instance.human_name?( 'CUP STEPHEN A', 80 ) }

      it { should be_true }

    end

  end

  context '#given_names' do

    subject { recognition_instance.given_names.size }

    it { should == 5678 }

  end

  context '#given_names_all_downcase' do

    subject { recognition_instance.given_names_all_downcase.first }

    it { should == 'aj' }

  end

  context '#given_names_all_upcase' do

    subject { recognition_instance.given_names_all_upcase.first }

    it { should == 'AJ' }

  end

  context '#all_name_words_downcase' do

    subject { recognition_instance.all_name_words_downcase.size }

    it { should == 14297 }

  end

  context '#all_name_words_upcase' do

    subject { recognition_instance.all_name_words_upcase.size }

    it { should == 14297 }

  end

  context '#prefixes' do

    subject { recognition_instance.send( :prefixes ).sort }

    it { should == ["DR", "DR.", "Dr", "Dr.", "GENERAL", "GENERAL.", "General", "General.", "MISS", "MISS.", "MR", "MR.", "MRS", "MRS.", "Miss", "Miss.", "Mr", "Mr.", "Mrs", "Mrs.", "dr", "dr.", "general", "general.", "miss", "miss.", "mr", "mr.", "mrs", "mrs."] }

  end

  context '#suffixes' do

    subject { recognition_instance.send( :suffixes ).sort }

    it { should == ["ESQ", "ESQ.", "Esq", "Esq.", "III", "III", "III.", "III.", "IV", "IV", "IV.", "IV.", "JR", "JR.", "Jr", "Jr.", "V", "V", "V.", "V.", "esq", "esq.", "iii", "iii.", "iv", "iv.", "jr", "jr.", "v", "v."] }

  end

  context '#probability_is_human_name' do

    context 'when all words are a name part' do

      subject { recognition_instance.probability_is_human_name( 'Mr. Charles Langford III' ) }

      it { should == 100 }

    end

    context 'when there is one word that is not a name part' do

      subject { recognition_instance.probability_is_human_name( 'Introducing Mr. Charles Langford III' ) }

      it { should == 80 }

    end

    context 'when there are two words that are not a name part' do

      subject { recognition_instance.probability_is_human_name( 'Home of Mr. Charles Langford III' ) }

      it { should == 60 }

    end

    context 'when there are five words that are not a name part' do

      subject { recognition_instance.probability_is_human_name( 'This is the home of Mr. Charles Langford III' ) }

      it { should == 0 }

    end

    context 'when there are six words that are not a name part' do

      subject { recognition_instance.probability_is_human_name( 'It is at the home of Mr. Charles Langford III' ) }

      it { should == 0 }

    end

  end

end

