class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.references :sku, index: true
      t.references :shop, index: true
      t.string :availability
      t.decimal :price, precision: 8, scale: 2

      t.timestamps
    end
  end
end
