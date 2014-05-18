class CreateFtsAddresses < ActiveRecord::Migration
  def up
      execute 'CREATE VIRTUAL TABLE fts_addresses USING fts4(name)'
  end
  def down
    drop_table :fts_addresses
  end
end
