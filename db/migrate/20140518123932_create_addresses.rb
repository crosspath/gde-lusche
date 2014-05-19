class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :name
      t.integer :adrtype
      t.references :parent, index: true

      t.timestamps
    end
  end
end
