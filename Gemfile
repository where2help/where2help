source 'https://rubygems.org'
ruby '2.5.1'

gem 'rails', '~> 5.2.4'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'pg'
gem 'puma', '~> 3'
gem 'sass-rails'

# TODO: Upgrade font-awesome-sass and bootstrap-rails to newer version.
# Starting with font-awesome-sass 5.0.13 and bootstrap-rails 4.4.1 however#
# these gem depends on sassc (instead of sass) and to compile sassc we need GCC 4.6 or newer.
# On CentOS 6.9 the currently installed version is 4.4.7 (as of
# 2018-05-22). So for now we have to stick with the old versions.
# https://github.com/FortAwesome/font-awesome-sass/commit/2cfca7ba60cd7bc065bcabfdbc6c476ca1a2f9ad
# https://github.com/sass/sassc-ruby/issues/37#issuecomment-205449016
gem 'bootstrap-sass', '= 3.3.7'
gem 'font-awesome-sass', '= 5.0.9'

gem 'flag-icons-rails'
gem 'momentjs-rails'

gem 'devise'

gem 'uglifier'
gem 'coffee-rails'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder'

gem 'leaflet-rails'

gem 'ri_cal'

gem 'rails_autolink'
gem 'faker', require: false

gem 'pry-rails'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'rspec-json_expectations'
  gem 'factory_bot_rails'
  gem 'rails-controller-testing'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'pry-byebug', require: false
  gem 'i18n-tasks', '~> 0.9.21'
end

group :test do
  gem 'database_cleaner'

  gem 'shoulda-matchers'
  gem 'shoulda-context'
end

group :development do
  gem 'sitemap_generator'
  gem 'web-console'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'bullet'
  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.2'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# ActiveJob backend
gem 'sucker_punch'

# Admin Interface
gem 'inherited_resources'
gem 'activeadmin'
gem 'formtastic-bootstrap'
gem 'cocoon'
gem 'histogram'

# Soft delete
gem "paranoia", "~> 2.2"

# Pagination
gem 'kaminari'

# Task Scheduling
gem 'whenever', require: false

# CSS-styled emails, auto-generated text-variants
gem 'premailer-rails'
gem 'nokogiri'

gem 'invisible_captcha'

gem 'rails-i18n', '~> 5.1' # For rails 5.0.x, 5.1.x and 5.2.x

gem 'dotenv-rails'
