# Load the Rails application.
require_relative 'application'
Dir[Rails.root.join('lib/**/*.rb')].each { |f| require f }
Rails.logger = Logger.new(STDOUT)

# Initialize the Rails application.
Rails.application.initialize!
