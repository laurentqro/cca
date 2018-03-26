source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.0.rc2'
gem 'pg'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bcrypt', '~> 3.1.7'
gem 'sidekiq', '~> 5.1.1'
gem 'mailgun-ruby', '~> 1.1.8'
gem 'shrine', '~> 2.9.0'
gem 'ancestry', '~> 3.0.1'
gem 'webpacker', '~> 3.4.1'
gem 'aws-sdk-s3', '~> 1'
gem 'jquery-rails', '~> 4.3'
gem 'jquery-fileupload-rails', '0.4'
gem 'tzinfo-data'
gem 'devise', '~> 4.4'
gem 'devise_invitable', '~> 1.7.0'
gem 'pretender', '~> 0.3.2'
gem 'font-awesome-rails', '~> 4.7'

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
  gem 'letter_opener', '~> 1.6.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
