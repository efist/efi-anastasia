class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.integer :skroutz_id
      t.string  :name
      t.string  :link
      t.string  :image_url
      t.boolean :free_shipping
      t.decimal :free_shipping_from, precision: 8, scale: 2
      t.decimal :shipping_min_price, precision: 8, scale: 2
      t.integer :reviews_count
      t.decimal :review_score, precision: 8, scale: 2
      t.timestamps
    end
  end
end
