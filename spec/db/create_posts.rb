class CreatePosts < ActiveRecord::Migration
  def self.up
    execute "CREATE EXTENSION IF NOT EXISTS hstore"
    create_table :posts do |t|
      t.hstore :properties

      t.timestamps
      t.integer :lock_version, default: 0, null: false
    end

  end
 
  def self.down
    drop_table :posts
  end
end
