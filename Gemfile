source "https://rubygems.org"

gem "bundler"
gem "rake"
gem "hanami",       "~> 0.9"
gem "hanami-model", "~> 0.7"

gem "pg"
gem "beaneater"
gem "faraday"

group :test, :development do
  gem 'dotenv', '~> 2.0'
end

group :development do
  gem "shotgun"
end

group :test do
  gem "rspec"
  gem "database_cleaner"
end

group :production do
  gem "puma"
end
