module NameableRecord
  module ActiveRecordExtensions
  def self.included( base )
    base.extend ActsMethods
  end

  module ActsMethods
    def has_name( *args )
      unless included_modules.include? InstanceMethods
        self.class_eval { extend ClassMethods }
        include InstanceMethods
      end
      initialize_compositions( args )
    end

    alias_method :has_names, :has_name
  end

  module ClassMethods
    def initialize_compositions( attrs )
      attrs.each do |attr|
        composed_of attr, :class_name => "Nameable::Name", :mapping => [["#{attr}_last", "last"], ["#{attr}_first", "first"],
          ["#{attr}_prefix", "prefix"], ["#{attr}_middle", "middle"],  ["#{attr}_suffix", "suffix"]]
      end
    end
  end

  module InstanceMethods

  end
end
end