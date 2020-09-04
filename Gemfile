source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.2'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'dotenv', '~> 2.7'

  # So you don't have to recompile ruby to get readline support
  # This means it'll be easier to get cmd history on new pry sessions
  # If you want to use the compiled readline, set USE_SYSTEM_READLINE=1
  # (it must be set in your actual environment, not a .env file)
  gem 'rb-readline'

  # Debugging tools
  gem 'pry-rails'
  gem 'pry-byebug',         require: false
  gem 'pry-remote',         require: false
  gem 'pry-rescue',         require: false
  gem 'pry-stack_explorer', require: false

  gem 'rubocop', '~> 0.76.0', require: false
  gem 'rubocop-performance', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# TODO Update this once my PR to the main alphavantage is approved.
gem "alphavantagerb", "1.5.0", git: "git://github.com/tylerhaugen-stanley/AlphaVantageRB.git", branch: 'add_fundamental_data_support'

gem 'oj', '~> 2.18'
