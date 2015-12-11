source 'https://rubygems.org'
ruby '2.2.3'
gem 'rails', '3.2.22'
gem 'tinymce-rails'

group :assets do
  gem 'sass-rails', '>= 3.2' # sass-rails needs to be higher than 3.2
  gem 'bootstrap-sass', '~> 3.3.1.0'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'rails_12factor'
gem 'paperclip-googledrive'
gem 'rolify'
gem 'authority'
gem 'paper_trail'
gem 'nokogiri'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem "rspec-rails", ">= 2.12.2", :group => [:development, :test]
gem "factory_girl_rails", ">= 4.2.0", :group => [:development, :test]
gem "omniauth", ">= 1.1.3"
gem "omniauth-google-oauth2"
gem "simple_form", ">= 2.1.0"
gem "figaro", ">= 0.6.3"
gem 'wicked_pdf', :git => "git://github.com/mileszs/wicked_pdf.git"

gem 'wkhtmltopdf-binary', :group => [:test, :development]
gem 'wkhtmltopdf-heroku', :group => :production

gem 'htmlentities'

gem 'pg', :group => [:production, :development]

group :development do
  gem "binding_of_caller"
  gem 'webrick', '~> 1.3.1'
  gem "better_errors", ">= 0.7.2"
  gem "quiet_assets", ">= 1.0.2"
  gem "annotate"
  gem "test-unit"
end

group :test do
  gem "database_cleaner", ">= 1.0.0.RC1"
  gem "capybara", ">= 2.0.3"
  gem "email_spec", ">= 1.4.0"
  gem "sqlite3"
end
