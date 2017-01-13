Hanami::Model.migration do
  change do
    create_table :urls do
      primary_key :id

      column :href, String, null: false

      # these are automatically handled by the hanami-model ORM
      column :created_at, Time, null: false
      column :updated_at, Time, null: false

      # build an index on the +href+ column so that calls to URL shortening
      # calls as well as link stats calls can look up URLs faster.
      #
      # As there is no concept of users in the app at the moment, the
      # URLs are forced to be unique. However, if the concept of users
      # is later added to the application, the unique index must be
      # the [user_id, href] combination.
      index :href, unique: true
    end
  end
end
