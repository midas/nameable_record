module NameableRecord

  class Name

    PREFIXES = %w(Mr Mrs Miss Dr).map  { |p| [p, "#{p}.", p.upcase, "#{p.upcase}.", p.downcase, "#{p.downcase}."] }.flatten
    SUFFIXES = %w(Jr III IV V Esq).map { |p| [p, "#{p}.", p.upcase, "#{p.upcase}.", p.downcase, "#{p.downcase}."] }.flatten

    attr_reader :first, :middle, :last, :prefix, :suffix

    def initialize( last, first, prefix=nil, middle=nil, suffix=nil )
      @first, @middle, @last, @prefix, @suffix = first, middle, last, prefix, suffix

      @name_pattern_map = {
          /%l/ => last || "",
          /%f/ => first || "",
          /%m/ => middle || "",
          /%p/ => prefix || "",
          /%s/ => suffix || "",
      }

      @@predefined_patterns = {
        :full => " %l, %f %s",
        :full_with_middle => " %l, %f %m %s",
        :full_with_prefix => " %l, %p %f %s",
        :full_sentence => "%p %f %l %s",
        :full_sentence_with_middle => "%p %f %m %l %s"
      }

      self.freeze
    end

    # Creates a name based on pattern provided.  Defaults to given + additional
    # given + family names concatentated.
    #
    # Symbols:
    #   %l - last name
    #   %f - first name
    #   %m - middle name
    #   %p - prefix
    #   %s - suffix
    #
    def to_s( pattern="" )
      if pattern.is_a?( Symbol )
        to_return = @@predefined_patterns[pattern]
      else
        to_return = pattern
      end
      to_return = @@predefined_patterns[:full] if to_return.empty?

      @name_pattern_map.each do |pat, replacement|
        to_return = to_return.gsub( pat, replacement )
      end

      to_return.strip
    end

    def ==( another_name )
      return false unless another_name.is_a?( self.class )

      %w(last first middle suffix prefix).map do |attr|
        another_name.send( attr ) == send( attr )
      end.all? { |r| r == true }
    end

    def self.parse( address )
      unless [Array, Hash, String].include?( address.class )
        raise "Cannot convert #{address.class.to_s.downcase} to an NameableRecord::Name"
      end 
      self.send( :"parse_#{address.class.to_s.downcase}", address )
    end

    def self.convert( address ) #:nodoc:
      parse( address )
    end

  private

    def self.prefixed?( name )
      unless [Array, String].include?( name.class )
        raise "Cannot determine prefixed for #{address.class.to_s.downcase}"
      end

      name_parts = name.is_a?( Array ) ?
                     name :
                     name.split( ' ' )

      PREFIXES.include?( name_parts.first )
    end

    def self.suffixed?( name )
      unless [Array, String].include?( name.class )
        raise "Cannot determine prefixed for #{address.class.to_s.downcase}"
      end

      name_parts = name.is_a?( Array ) ?
                     name :
                     name.split( ' ' )

      SUFFIXES.include?( name_parts.first )
    end

    def self.middle_named?( name )
      unless [Array, String].include?( name.class )
        raise "Cannot determine prefixed for #{address.class.to_s.downcase}"
      end

      name_parts = name.is_a?( Array ) ?
                     name :
                     name.split( ' ' )

      name_parts_size = name_parts.size
      name_parts_size -= 1 if prefixed?( name_parts )
      name_parts_size -= 1 if suffixed?( name_parts )

      name_parts_size == 3
    end

    def self.parse_array( name ) #:nodoc:
      is_prefixed     = prefixed?( name )
      is_middle_named = middle_named?( name )

      prefix = is_prefixed ? name.first : nil
      first  = is_prefixed ? name[1] : name.first

      if is_prefixed
        if is_middle_named
          middle = name[2]
          last   = name[3]
        else
          middle = nil
          last = name[2]
        end
      else
        if is_middle_named
          middle = name[1]
          last   = name[2]
        else
          middle = nil
          last   = name[1]
        end
      end

      suffix = suffixed?( name ) ? name.last : nil

      NameableRecord::Name.new( first, last, prefix, middle, suffix )
    end

    def self.parse_hash( name ) #:nodoc:
      first  = name['first'] || name[:first]
      last   = name['last'] || name[:last]
      prefix = name['prefix'] || name[:prefix]
      middle = name['middle'] || name[:middle]
      suffix = name['suffix'] || name[:suffix]

      NameableRecord::Name.new( first, last, prefix, middle, suffix )
    end

    def self.parse_string( name ) #:nodoc:
      parse_array( name.split( ' ' ) )
    end

  end

end

