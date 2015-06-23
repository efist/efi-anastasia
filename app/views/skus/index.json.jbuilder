json.array!(@skus) do |sku|
  json.extract! sku, :id, :name, :price_max, :price_min, :image
  json.url sku_url(sku, format: :json)
end
