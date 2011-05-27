$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
require 'nameable_record/active_record_extensions'
require 'nameable_record/name'

module NameableRecord
  VERSION = '0.1.0'
end

ActiveRecord::Base.send( :include, NameableRecord::ActiveRecordExtensions ) if defined?( ActiveRecord::Base )

