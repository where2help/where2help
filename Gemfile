# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.5.1'

gem 'bootsnap', '>= 1.1.0', require: false
gem 'pg'
gem 'puma'
gem 'rails', '5.2.1'
gem 'sass-rails'

gem 'bootstrap-sass'

# TODO Upgrade font-awesome-sass to newer version.
# Starting with 5.0.13 however the font-awesome-sass gem depends on
# sassc (instead of sass) and to compile sassc we need GCC 4.6 or newer.
# On CentOS 6.9 the currently installed version is 4.4.7 (as of
# 2018-05-22). So for now we have to stick with version 5.0.9.
# https://github.com/FortAwesome/font-awesome-sass/commit/2cfca7ba60cd7bc065bcabfdbc6c476ca1a2f9ad
# https://github.com/sass/sassc-ruby/issues/37#issuecomment-205449016
gem 'font-awesome-sass', '= 5.0.9'

gem 'flag-icons-rails'
gem 'momentjs-rails'

gem 'devise'

gem 'coffee-rails'
gem 'uglifier'

gem 'jbuilder'
gem 'jquery-rails'
gem 'turbolinks'

gem 'leaflet-rails'

gem 'ri_cal'

gem 'faker', require: false
gem 'rails_autolink'

gem 'pry-rails'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem "better_errors"
  gem "binding_of_caller"
  gem 'factory_bot_rails'
  gem 'i18n-tasks', '~> 0.9.21'
  gem 'pry-byebug', require: false
  gem 'rails-controller-testing'
  gem 'rspec-json_expectations'
  gem 'rspec-rails'
end

group :test do
  gem 'database_cleaner'

  gem 'shoulda-context'
  gem 'shoulda-matchers'
end

group :development do
  gem 'bullet'
  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem "relaxed-rubocop"
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'web-console'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# ActiveJob backend
gem 'sucker_punch'

# Admin Interface
gem 'activeadmin'
gem 'cocoon'
gem 'formtastic-bootstrap'
gem 'histogram'
gem 'inherited_resources'

# Soft delete
gem "paranoia", "~> 2.2"

# Pagination
gem 'kaminari'

# Task Scheduling
gem 'whenever', require: false

# CSS-styled emails, auto-generated text-variants
gem 'nokogiri'
gem 'premailer-rails'

gem 'invisible_captcha'

gem 'rails-i18n', '~> 5.1' # For rails 5.0.x, 5.1.x and 5.2.x

gem 'dotenv-rails'
