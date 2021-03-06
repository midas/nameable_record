module NameableRecord

  class Name

    attr_reader :first, :middle, :last, :prefix, :suffix

    def initialize( *args )
      @last, @first, @prefix, @middle, @suffix = args

      self.freeze
    end

    def ==( another_name )
      return false unless another_name.is_a?( self.class )

      %w(last first middle suffix prefix).map do |attr|
        another_name.send( attr ) == send( attr )
      end.all? { |r| r == true }
    end

    def eql?( another_name )
      self == another_name
    end

    def <=>( another_name )
      self.to_s( :full_with_middle ) <=> another_name.to_s( :full_with_middle )
    end

    # Creates a name based on pattern provided.  Defaults to last, first.
    #
    # Symbols:
    #   %l - last name
    #   %f - first name
    #   %m - middle name
    #   %p - prefix
    #   %s - suffix
    #
    def to_s( pattern='%l, %f' )
      if pattern.is_a?( Symbol )
        return conversational if pattern == :conversational
        return sortable if pattern == :sortable
        pattern = PREDEFINED_PATTERNS[pattern]
      end

      PATTERN_MAP.inject( pattern ) do |name, mapping|
        name = name.gsub( mapping.first,
                          (send( mapping.last ) || '') )
      end
    end

    # Returns the name in a conversational format.
    #
    def conversational
      [
        prefix,
        first,
        middle,
        last,
        suffix
      ].reject( &:blank? ).
        join( ' ' )
    end

    # Returns the name in a sortable format.
    #
    def sortable
      [
        last,
        [
          prefix,
          first,
          middle,
          suffix
        ].reject( &:blank? ).
          join( ' ' )
      ].reject( &:blank? ).
        join( ', ' )
    end

    PREDEFINED_PATTERNS = {
      :full                      => "%l, %f %s",
      :full_with_middle          => "%l, %f %m %s",
      :full_with_prefix          => "%l, %p %f %s",
      :full_sentence             => "%p %f %l %s",
      :full_sentence_with_middle => "%p %f %m %l %s"
    }.freeze

    PATTERN_MAP = {
       /%l/ => :last,
       /%f/ => :first,
       /%m/ => :middle,
       /%p/ => :prefix,
       /%s/ => :suffix
    }.freeze

    PREFIX_BASE =  %w(Mr Mrs Miss Dr General Pastor Bishop Agent Rep)  # The order of this matters because of PREFIXES_CORRECTIONS
    SUFFIX_BASE =  %w(Jr III V IV Esq MD DDS) # The order of this matters because of SUFFIXES_CORRECTIONS

    PREFIXES    = PREFIX_BASE.map { |p| [p, "#{p}.", p.upcase, "#{p.upcase}.", p.downcase, "#{p.downcase}."] }.flatten.sort
    SUFFIXES    = SUFFIX_BASE.map { |p| [p, "#{p}.", p.upcase, "#{p.upcase}.", p.downcase, "#{p.downcase}."] }.flatten.sort

    PREFIXES_CORRECTIONS = Hash[*PREFIX_BASE.map do |base|
                             PREFIXES.grep( /#{base}/i ).map { |p| [p,base] }
                           end.flatten]

    SUFFIXES_CORRECTIONS = Hash[*SUFFIX_BASE.map do |base|
                             SUFFIXES.grep( /#{base}/i ).map { |p| [p,base] }
                           end.flatten]

  end

end

