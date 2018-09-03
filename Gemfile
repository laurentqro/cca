source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.1'
gem 'pg'
gem 'puma', '~> 3.12'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bcrypt', '~> 3.1.12'
gem 'sidekiq', '~> 5.2.1'
gem 'mailgun-ruby', '~> 1.1.10'
gem 'shrine', '~> 2.12.0'
gem 'ancestry', '~> 3.0.2'
gem 'webpacker', '~> 3.5.5'
gem 'aws-sdk-s3', '~> 1'
gem 'jquery-rails', '~> 4.3'
gem 'jquery-fileupload-rails', '0.4.7'
gem 'tzinfo-data'
gem 'devise', '~> 4.5'
gem 'devise_invitable', '~> 1.7.4'
gem 'pretender', '~> 0.3.2'
gem 'font-awesome-rails', '~> 4.7'
gem 'active_model_serializers', '~> 0.10.0'

group :development, :test do
  gem 'chromedriver-helper'
  gem 'dotenv-rails', '~> 2.5.0'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 3.7'
  gem 'selenium-webdriver'
  gem 'webmock', '~> 3.4'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'letter_opener', '~> 1.6.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
