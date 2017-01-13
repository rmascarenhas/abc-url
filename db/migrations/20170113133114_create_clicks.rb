Hanami::Model.migration do
  change do
    create_table :clicks do
      primary_key :id
      foreign_key :url_id, :urls, null: false

      column :ip,         String, null: false
      column :user_agent, String, null: false
      column :referer,    String
      column :lat,        Float
      column :lng,        Float
      column :city,       String
      column :region,     String
      column :country,    String, null: false

      column :created_at, Time, null: false
      column :updated_at, Time, null: false
    end
  end
end
