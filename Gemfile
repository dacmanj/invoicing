source 'https://rubygems.org'
gem 'rails', '3.2.13'

group :assets do
  gem 'sass-rails', '>= 3.2' # sass-rails needs to be higher than 3.2
  gem 'bootstrap-sass', '~> 3.0.2.0'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'tinymce-rails'

end


gem "prawn", "~> 0.12.0"
gem 'jquery-rails'
gem "rspec-rails", ">= 2.12.2", :group => [:development, :test]
gem "capybara", ">= 2.0.3", :group => :test
gem "database_cleaner", ">= 1.0.0.RC1", :group => :test
gem "email_spec", ">= 1.4.0", :group => :test
gem "factory_girl_rails", ">= 4.2.0", :group => [:development, :test]
gem "omniauth", ">= 1.1.3"
gem "omniauth-google-oauth2"
gem "simple_form", ">= 2.1.0"
gem "figaro", ">= 0.6.3"
gem 'wicked_pdf'
gem 'pg', :group => :production

group :development do
  gem "binding_of_caller"
  gem 'webrick', '~> 1.3.1'
  gem 'pg'
  gem "better_errors", ">= 0.7.2"
  gem "quiet_assets", ">= 1.0.2"
  gem "annotate"
end

group :test do
  gem "capybara", ">= 2.0.3"
  gem "database_cleaner", ">= 1.0.0.RC1"
  gem "email_spec", ">= 1.4.0"
  gem "sqlite3"
end