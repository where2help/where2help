source 'https://rubygems.org'
ruby '2.3.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 5.0.0.beta3', '< 5.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

gem 'bootstrap-sass'
gem 'font-awesome-sass'
gem 'momentjs-rails', '>= 2.9.0'
#gem 'bootstrap3-datetimepicker-rails', '~> 4.17.37'

gem 'devise', '>= 4.0.0.rc2'

#gem 'devise-bootstrap-views'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes

gem 'faker'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# Action Cable dependencies for the Redis adapter
gem 'redis', '~> 3.0'

gem 'leaflet-rails'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'rake', '~> 10.5.0'  #problems with 11.0.1

group :production do
  gem 'rails_12factor', '~> 0.0.3'
end

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails', '>= 3.5.0.beta2'
  gem 'factory_girl_rails'
  gem 'rails-controller-testing' # can be removed once rspec 3.5.0 is fully out
end

group :test do
  gem 'database_cleaner'
  gem 'shoulda'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'bullet'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# ActiveJob backend
gem 'sucker_punch'

# Admin Interface
gem 'activeadmin', '>= 1.0.0.pre2'
gem 'formtastic-bootstrap'
gem "cocoon"


# Statemachine
gem 'aasm', '~> 4.9'
