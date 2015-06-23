class Sku < ActiveRecord::Base
  has_many :products
  has_many :shops, through: :products
  
  @@access_token=ENV['SKROUTZ']
  
  def self.fetch(sku_id)
    #begin
      json = JSON.parse(`curl -s -XGET https://api.skroutz.gr/skus/#{sku_id} -H 'Accept: application/vnd.skroutz+json; version=3' -H 'Authorization: #{@@access_token}'`)
      if json.has_key?('error')
        raise "error contacting skroutz: #{json['error']}"
      end
      #ap json
      sku = Sku.create(
        name: json['sku']['name'] ,
        price_max: json['sku']['price_max'] ,
        price_min: json['sku']['price_min'] ,
        image: json['sku']['images']['main'])
        
      puts "#{sku_id}\t#{json['sku']['name']}"
      json = JSON.parse(`curl -s -XGET https://api.skroutz.gr/skus/#{sku_id}/products -H 'Accept: application/vnd.skroutz+json; version=3' -H 'Authorization: #{@@access_token}'`)
      
      #ap json["products"]
      json["products"].each do |product|
      puts "product"
      #ap product
      
      unless Shop.exists?(skroutz_id:  product["shop_id"])
        puts "create shop"
        ap shop_json = JSON.parse(`curl -s -XGET https://api.skroutz.gr/shops/#{product["shop_id"]} -H 'Accept: application/vnd.skroutz+json; version=3' -H 'Authorization: #{@@access_token}'`)
        
        
        Shop.create(name:               shop_json["shop"]["name"],
                    skroutz_id:         shop_json["shop"]["id"],
                    link:               shop_json["shop"]["link"],
                    image_url:          shop_json["shop"]["image_url"],
                    free_shipping:      shop_json['shop']['shipping']["free"],
                    free_shipping_from: shop_json['shop']['shipping']["free_from"],
                    shipping_min_price: shop_json['shop']['shipping']["min_price"],
                    reviews_count:      shop_json['shop']["reviews_count"],
                    review_score:       shop_json['shop']["review_score"]
                   )
      end
      shop = Shop.find_by skroutz_id: product["shop_id"]
      sku.products.push(
        Product.create( name: product["name"],
                        availability: product["availability"],
                        price: product["price"],
                        shop: shop))
      end
      
      return sku
    #rescue
    #  return nil
    #end
  end
  
# Αλγόριθμος επιλογής προϊόντος με βάση τη διαθεσιμότητά του
def fastest_product

  # Αρχικοποίηση μεταβλητής όπου θα αποθηκευθούν τα προϊόντα
  fastest_products = []
  
  # Τα δεδομένα που προέρχονται από το skroutz και αφορούν τη
  # διαθεσιμότητα των προϊόντων έχουν τις εξής δυνατές τιμές:
  # • Σε απόθεμα
  # • 1 έως 3 ημέρες
  # • 4 έως 7 ημέρες
  # • 7+ ημερες
  # • Κατόπιν Παραγγελίας
  # • nil (χωρίς τιμή)
  #
  # Αυτές οι τιμές είναι σε μορφή κειμένου και βρίσκονται
  # στη μεταβλητή possible_availabilities
  possible_availabilities = ["Σε απόθεμα",
                             "1 έως 3 ημέρες",
                             "4 έως 7 ημέρες",
                             "7+ ημερες",
                             "Κατόπιν Παραγγελίας",
                             nil]
  
  # Με μια δομή επανάληψης επιλέγουμε πρώτα τα στοιχεία που
  # έχουν availability "σε απόθεμα". Αυτά τα στοιχεία τα
  # ταξινομούμε με βάση την τιμή τους και τα εισάγουμε στη
  # μεταβλητή cheapest_products μετά κάνουμε το ίδιο για τα
  # στοιχεία που έχουν availability "1 έως 3 ημέρες"
  # και ούτω καθεξής.
  
  # για κάθε τιμή availability
  possible_availabilities.each do |availability|
    
    # H συνάρτηση select είναι μια συνάρτηση που έχει η δομή
    # Array της Ruby και χρησιμοποιείται για να φιλτράρουμε
    # τα στοιχεία ενός Array. Στην περίπτωσή μας φιλτράρουμε
    # τα στοιχεία του Array products με βάση την τιμή
    # availability που έχουν. Τα στοιχεία που τηρούν αυτό
    # τον έλεγχο τα αποθηκεύουμε προσωρινά στην μεταβλητή tmp
    tmp = products.select do |p|
      p.availability == availability
    end
    
    # H συνάρτηση sort είναι μια συνάρτηση που έχει η δομή
    # Array της Ruby και χρησιμοποιείται για να ταξινομήσουμε
    # τα στοιχεία του array που θέλουμε με βάση κάποια τιμή
    # που έχουν. Στην περίπτωσή μας ταξινομούμε τα στοιχεία
    # του Array tmp με βάση την τιμή που έχουν. Τo
    # ταξινομημένο array αποθηκεύεται πάλι στη μεταβλητή tmp
    tmp.sort! do |x,y|
      y[:price] <=> x[:price]
    end
    
    # αντιστροφή του array tmp ώστε τα φθηνότερα
    # προϊόντα να πάνε πρώτα
    tmp.reverse!
    
    # Τέλος το array tmp συνενώνεται στο τέλος του
    # array fastest_products
    fastest_products += tmp
  end
  
  # H συνάρτηση επιστρέφει το πρώτο προϊόν από το array
  # fastest_products που περιέχει τα προϊόντα που πρωτίστως
  # βρίσκονται σε διαθεσιμότητα και δευτερευόντως
  # έχουν χαμηλότερη τιμή.
  return fastest_products.first
end


# Αλγόριθμος επιλογής φθηνότερου προϊόντος
def cheapest_product
  
  # ταξινόμηση των προϊόντων με βάση την τιμή τους και
  # ανάθεση του ταξινομημένου array στην μεταβλητή tmp
  tmp = products.sort do |x,y|
    y[:price] <=> x[:price]
  end
  
  # το τελευταίο στοιχείο του array είναι και το φθηνότερο
  # οπότε επέστρεψε αυτό
  return tmp.last
end


# Αλγόριθμος επιλογής προϊόντος με βάση το κατάστημα
#
# ο αλγόριθμος δέχεται σαν όρισμα μια ταξινομημένη λίστα
# με τα καταστήματα από τα οποία θα προτιμούσαμε να αγοράσουμε
# το προϊόν. Και επιστρέφει το προϊόν που βρίσκεται στο
# κατάστημα υψηλότερης προτίμησης
def product_by_shop (shops_list)
  shops_list.each do |shop|
    products.each do |product|
      if product.shop == shop
        return product
      end
    end
  end
  return nil
end

end
