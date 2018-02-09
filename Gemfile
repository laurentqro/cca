source 'https://rubygems.org' 
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.4'
gem 'pg'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bcrypt', '~> 3.1.7'
gem 'sidekiq', '~> 5.0.5'
gem 'mailgun-ruby', '~> 1.1.8'
gem 'shrine', '~> 2.8.0'
gem 'ancestry', '~> 3.0.1'
gem 'webpacker', '~> 3.0'
gem 'aws-sdk-s3', '~> 1'
gem 'jquery-rails', '~> 4.3'
gem 'jquery-fileupload-rails', '0.4'
gem 'tzinfo-data'
gem 'devise', '~> 4.4'
gem 'devise_invitable', '~> 1.7.0'
gem 'pretender', '~> 0.3.2'

group :development, :test do
  gem 'dotenv-rails', '~> 2.2.1'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
  gem 'webmock', '~> 3.1'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'letter_opener', '~> 1.4.1'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano', '~> 3.6'
  gem 'capistrano-rails', '~> 1.3'
  gem 'capistrano3-puma', '~> 3.1.1'
  gem 'capistrano-rbenv', '~> 2.1'
end
