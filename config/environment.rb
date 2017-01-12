require "bundler/setup"
require "hanami/setup"
require "hanami/model"
require_relative "../lib/abc"
require_relative "../apps/web/application"

Hanami.configure do
  mount Web::Application, at: '/'

  model do
    adapter :sql, ENV["DATABASE_URL"]

    migrations "db/migrations"
    schema     "db/schema.sql"
  end
end
