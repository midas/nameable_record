module NameableRecord
  class Name
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
  end
end