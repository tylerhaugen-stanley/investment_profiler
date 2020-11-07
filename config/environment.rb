# dotfiles = []

# TODO why does dotenv not loan my .env.development.local file?
require 'dotenv'
# Dotenv.load('.env.development.local', '.env')
Dotenv.load


# Load the Rails application.
require_relative 'application'
Dir[Rails.root.join('lib/**/*.rb')].each { |f| require f }
Rails.logger = Logger.new(STDOUT)

# Initialize the Rails application.
Rails.application.initialize!
