$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'chore'

RSpec.configure do |config|
  config.before do 
    Chore.logger = double('logger').as_null_object
  end 
end
