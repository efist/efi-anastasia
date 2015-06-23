class CreateSkusUsers < ActiveRecord::Migration
  def change
    create_table :skus_users, :id => false do |t|
      t.references :sku
      t.references :user
    end
    add_index :skus_users, [:sku_id, :user_id]
    add_index :skus_users, :user_id
  end
end
