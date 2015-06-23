module ProductsHelper
  def shops_products_hash (products)
    shops = {}
    products.each do |product|
      shops[product.shop] = [] unless shops[product.shop]
      shops[product.shop].push product
    end
    return shops
  end
end
