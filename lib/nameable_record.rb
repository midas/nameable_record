require "nameable_record/railtie" if defined?( ::Rails )
require "nameable_record/version"

module NameableRecord

  autoload :ActiveRecordExtensions, 'nameable_record/active_record_extensions'
  autoload :Name,                   'nameable_record/name'

end

