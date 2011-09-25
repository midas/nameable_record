module NameableRecord::NameRecognition

  def surnames
    @surnames ||= surnames_from_file
  end

  def given_names
    @given_names ||= given_names_from_file
  end

  %w(downcase upcase).each do |desired_case|
    define_method "surnames_all_#{desired_case}" do
      surnames.map( &desired_case.to_sym )
    end

    define_method "given_names_all_#{desired_case}" do
      given_names.map( &desired_case.to_sym )
    end

    define_method "all_name_words_#{desired_case}" do
      (surnames + given_names + prefixes + suffixes + initials_downcase).map { |n| n.send( desired_case ) }.uniq
    end
  end

  def human_name?( name, lowest_affirmative_probabilty=100, disqualifying_words=[]  )
    probability_is_human_name( name, disqualifying_words ) >= lowest_affirmative_probabilty
  end

  def probability_is_human_name( name, disqualifying_words=[] )
    if name.match( /^[a-zA-Z]*\s*[a-zA-Z]{2}$/ )
      return probability_from_last_and_intials( name, :last_name_first => true )
    elsif name.match( /^[a-zA-Z]{2}\s*[a-zA-Z]*$/ )
      return probability_from_last_and_intials( name, :last_name_first => false )
    end

    name_parts = split_and_clean_name( name )

    return 0 if ((default_disqualifying_words + disqualifying_words) & name_parts).size > 0

    score = (100 - ((name_parts.size - (name_parts & all_name_words_downcase).size) * points_per_additional_word))
    score < 0 ? 0 : score
  end

  def default_disqualifying_words
    %w(
      corporation
      corp
      co
      llc
      ltd
    )
  end

private

  def points_per_additional_word
    20
  end

  def probability_from_last_and_intials( name, options )
    name_parts = split_and_clean_name( name )

    last_name = options[:last_name_first] ? name_parts.first : name_parts.last

    return ([last_name] & surnames_all_downcase).size == 1 ?
             100 :
             50
  end

  def split_and_clean_name( name )
    name.split( ' ' ).compact.map { |p| p.strip.downcase }
  end

  def prefixes
    NameableRecord::Name::PREFIXES
  end

  def suffixes
    NameableRecord::Name::SUFFIXES
  end

  def initials_downcase
    alphabet_downcase + alphabet_downcase.map { |l| "#{l}." }
  end

  def alphabet_downcase
    ('a'..'z').to_a
  end

  def surnames_from_file
    File.open( surnames_file_path, 'r' ) { |f| f.readlines }.map { |n| n.strip }
  end

  def surnames_file_path
    File.join File.dirname(__FILE__),
              'data',
               surnames_file_name
  end

  def surnames_file_name
    'surnames.txt'
  end

  def given_names_from_file
    File.open( given_names_file_path, 'r' ) { |f| f.readlines }.map { |n| n.strip }
  end

  def given_names_file_path
    File.join File.dirname(__FILE__),
              'data',
               given_names_file_name
  end

  def given_names_file_name
    'given-names.txt'
  end

end

