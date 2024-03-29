source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '>= 2.7'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem "pg", ">= 1.2"

gem "loofah", '~> 2.3.1'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# loads the .env file into the environment
gem 'dotenv-rails'

# for authentication
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-gitlab'
gem 'font-awesome-rails'
gem 'octokit', '~> 4.18'

# testing api calls
gem 'webmock'

# For oauth
gem 'devise'
# For setting permissions
gem 'cancancan', '~> 2.0'
# For managing roles
gem 'rolify'

gem 'bootstrap-sass', '~> 3.4.1'
gem 'jquery-rails'

# For managing spreadsheets such as the roster and gradebook
gem "roo", "~> 2.7.0"

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'pry-byebug'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# Currently, this does nothing but throw a warning. If someone needs to re-enable this, then uncomment this line and run:
# `bundle lock --add-platform x86-mingw32 x86-mswin32 x64-mingw32 java`
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Pagination
gem 'kaminari'
gem 'api-pagination'

gem "actionview", ">= 5.1.6.2"

gem 'omniauth-rails_csrf_protection', '~> 0.1'
gem 'sucker_punch'

# More accurate distance_of_time_in_words method
gem 'dotiw'
gem 'bootstrap-table-rails'
gem 'jquery-turbolinks'

# TODO: This can be changed to slack-ruby-client, which is a subset of the bot gem features.
gem 'slack-ruby-bot'

gem 'github_webhook', '~> 1.1'

gem 'react_on_rails', '~> 13.0.2'
gem 'webpacker', '~> 4'

gem 'pg_search'

gem 'wdm', '>= 0.1.0' if Gem.win_platform?

# To avoid security vulnerabilites flagged by GitHub
# we specific specific versions of these dependencies 
gem "rack", ">= 2.1.4"

gem "activesupport", ">= 5.2.4.3" 

group :development, :test do
  gem 'factory_bot_rails'
end

# Feature toggle (see: https://github.com/jnunemaker/flipper)
gem 'flipper'
gem 'flipper-ui'
gem 'flipper-active_record'

gem 'zlib'
