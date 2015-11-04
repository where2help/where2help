source 'https://rubygems.org'

gem 'rails', '4.2.4'
# Use sqlite3 as the database for Active Record
gem 'pg'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby
gem 'leaflet-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

gem 'sass-rails', '~> 5.0'            # SCSS support for stylesheets in the asset pipeline
gem 'uglifier', '>= 1.3.0'            # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '~> 4.1.0'        # Coffeescript support in the asset pipeline

gem 'jquery-rails'                    # JQ asset pipeline integration
gem 'jbuilder', '~> 2.0'              # Build JSON APIs with ease.
gem 'sdoc', '~> 0.4.0', group: :doc   # bundle exec rake doc:rails generates the API under doc/api.
gem 'unicorn'                         # Application server

gem 'bootstrap-sass'                  # Twitter Bootstrap integration
gem 'bootstrap-sass-extras'           # Twitter Bootstrap helpers (taken from less version)
gem 'font-awesome-rails'              # Better Icon Font
gem "simple_form"                     # Form Generation
gem 'datetimepicker-rails', github: 'zpaulovics/datetimepicker-rails', branch: 'master', submodules: true

gem 'devise'                          # Authentication
gem 'devise-bootstrap-views'          # Bootstrap integration for devise
gem 'devise_token_auth'               # Token generation for the API
gem 'omniauth'               # Token generation for the API
gem 'jsonapi-resources'               # API - Generator

gem 'sucker_punch'

gem 'kaminari'                        # pagination

gem 'pry-rails'

# External Client Deps
gem 'faraday', require: false
gem 'faraday-http-cache', require: false
gem 'faraday_middleware', require: false
gem 'typhoeus', require: false
gem 'oj', require: false
gem 'oj_mimic_json', require: false

group :production do
  gem "rails_12factor"
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'byebug'                        # Debugger
  gem 'foreman'
  gem 'guard'
  gem 'guard-livereload'
end

group :development, :test, :staging do
  gem 'dotenv-rails'
end

group :development do
  gem 'web-console', '~> 2.0'         # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'spring'                        # keeps application running in the background.

  gem 'better_errors'
  gem 'binding_of_caller'
  gem "letter_opener"
  gem "awesome_print"
end

group :test do
  gem 'faker'
end
