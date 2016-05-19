source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.15'

# Decorators
gem 'draper', '~> 1.3'

# Enumerations for Active Record
gem 'classy_enum', '~> 4.0'

# https://github.com/twbs/bootstrap-rubygem
gem 'bootstrap', '~> 4.0.0.alpha3'
# Bootstrap dependency
source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end
gem 'underscore-rails'

# Markdown
gem 'kramdown', '~> 1.9'

gem 'slim', '~> 3.0'


# View templates
gem 'haml-rails', '~> 0.9'


# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'awesome_print', :require => 'ap'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem 'active_record_query_trace'

  gem 'rspec-rails', '~> 3.0'
  gem 'guard-rspec', '~> 4.6'
  gem 'spring-commands-rspec', '~> 1.0'

  gem 'guard-livereload', '~> 2.5', require: false
  gem 'rack-livereload'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # https://github.com/rweng/pry-rails
  gem 'pry-rails', '~> 0.3.4'
  gem 'pry-doc', '~> 0.8.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'passenger'
end

group :deployment do
  gem 'berkshelf'
  gem 'vagrant-berkshelf'
end
