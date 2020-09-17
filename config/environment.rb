# dotfiles = []

# TODO: How do you get true false values in env vars? Are they always just strings? I think we
#   ran into this with UAT1/2
# TODO why does dotenv not loan my .env.development.local file?
require 'dotenv'
Dotenv.load('.env.development.local', '.env')
# Dotenv.load



# Load the Rails application.
require_relative 'application'
Dir[Rails.root.join('lib/**/*.rb')].each { |f| require f }
Rails.logger = Logger.new(STDOUT)

# Initialize the Rails application.
Rails.application.initialize!
