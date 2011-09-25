ActiveRecord::Base.configurations = YAML::load( IO.read( File.dirname(__FILE__) + '/../spec/database.yml' ) )
ActiveRecord::Base.establish_connection( 'test' )

silence_stream STDOUT do

  ActiveRecord::Schema.define :version => 1 do
    create_table :users, :force => true do |t|
      t.string :name_first, :anem_last, :name_middle, :name_prefix, :name_suffix
    end
  end

end

class User < ActiveRecord::Base
  has_name :name
end

