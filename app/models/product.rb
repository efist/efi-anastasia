class Product < ActiveRecord::Base
  belongs_to :sku
  belongs_to :shop
end
