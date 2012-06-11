module NameableRecord::ActiveRecordExtensions

  def self.included( base )
    base.extend ActsMethods
  end

  module ActsMethods

    def has_name( *args )
      args.each do |attr|

        composed_of attr, :class_name => "NameableRecord::Name", :mapping => [["#{attr}_last",   "last"],
                                                                              ["#{attr}_first",  "first"],
                                                                              ["#{attr}_prefix", "prefix"],
                                                                              ["#{attr}_middle", "middle"],
                                                                              ["#{attr}_suffix", "suffix"]]

        define_method "conversational_#{attr}" do
          [
            send( "#{attr}_prefix" ),
            send( "#{attr}_first" ),
            send( "#{attr}_middle" ),
            send( "#{attr}_last" ),
            send( "#{attr}_suffix" )
          ].reject( &:blank? ).
            join( ' ' )
        end

        define_method "sortable_#{attr}" do
          [
            send( "#{attr}_last" ),
            [
              send( "#{attr}_prefix" ),
              send( "#{attr}_first" ),
              send( "#{attr}_middle" ),
              send( "#{attr}_suffix" )
            ].reject( &:blank? ).
              join( ' ' )
          ].reject( &:blank? ).
            join( ', ' )
        end

      end
    end

    alias_method :has_names, :has_name

  end

end

