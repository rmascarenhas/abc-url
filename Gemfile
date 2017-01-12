source "https://rubygems.org"

gem "bundler"
gem "rake"
gem "hanami",       "~> 0.9"
gem "hanami-model", "~> 0.7"

gem "pg"

group :test, :development do
  gem 'dotenv', '~> 2.0'
end

group :production do
  gem "puma"
end

group :test do
  gem "rspec"
end
