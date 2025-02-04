source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~>6.0.0'
# Use bottstrap framework for nice web design and interface elements.
gem 'bootstrap', '~> 4.3', '>= 4.3.1'
#Trying to get forms to work
gem 'popper_js'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 5.0.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.12'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~>1.4.5', require: false

gem 'jquery-rails', '4.3.1'

#Pagination
gem 'pagy', '~> 3.3.2'
#Makes pagy run quicker
gem 'oj', '~> 3.7.12'

#Generate fake random test data
gem 'faker', '~> 1.9.3'

# Simple form bootsrap compatible
gem 'simple_form', '~>4.1.0'

# Format times in user's timezone
gem 'local_time', '~>2.1.0'

# Masking for phone number fields etc.
gem 'jquery_mask_rails', '~>0.1.0'

# Amazon SNS for sending text message.
gem 'aws-sdk-sns'

# Distance of time in words with more options and precision.
gem 'dotiw', '~>4.0.1'

# Webpacker - added when upgrading to rails 6.0
gem 'webpacker', '~>4.2.0'

# Pundit is to help with authorization/access profiles
gem 'pundit', '~>2.1.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~>3.2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'rails-controller-testing', '1.0.4'
  gem 'minitest',                 '5.13.0'
  gem 'minitest-reporters',       '1.1.14'
  # Require all my custome test cllasses and modules
  gem 'require_all'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
