require 'rails'

module NameableRecord

  class Railtie < ::Rails::Railtie

    initializer "nameable_record.initialize" do
      ActiveRecord::Base.send( :include, NameableRecord::ActiveRecordExtensions ) if defined?( ActiveRecord::Base )
    end

  end

end

