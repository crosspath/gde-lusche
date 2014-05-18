class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :name
      t.integer :type
      t.references :parent, index: true

      t.timestamps
    end
  end
end
