json.array!(@products) do |product|
  json.extract! product, :id, :name, :sku_id, :shop_id, :availability, :price
  json.url product_url(product, format: :json)
end
