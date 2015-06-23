class CreateSkus < ActiveRecord::Migration
  def change
    create_table :skus do |t|
      t.string :name
      t.decimal :price_max, precision: 8, scale: 2
      t.decimal :price_min, precision: 8, scale: 2
      t.string :image

      t.timestamps
    end
  end
end
