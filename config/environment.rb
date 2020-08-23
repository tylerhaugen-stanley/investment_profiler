# Load the Rails application.
require_relative 'application'

require 'dotenv'
Dotenv.load('.env.development.local', '.env')

Dir[Rails.root.join('lib/**/*.rb')].each { |f| require f }

# Initialize the Rails application.
Rails.application.initialize!
