class User < ActiveRecord::Base
has_secure_password
has_and_belongs_to_many :skus
has_many :products, through: :skus
has_many :shops, through: :products

# Αλγόριθμος επιλογής προϊόντων με βάση τη διαθεσιμότητα
def fastest_products
  
  # Αρχικοποίηση μεταβλητής όπου θα αποθηκευθούν τα προϊόντα 
  fastest_products = []
  
  skus.each do |sku|
    # έλεγχος για το αν κάποιο προίόν δεν υπάρχει
    unless sku.fastest_product.nil?
      # εισαγωγή του προϊόντος με την καλύτερη
      # διαθεσιμότητα στο array fastest_products.
      fastest_products.push(sku.fastest_product)
    end 
  end
  
  # επιστροφή array με τα προϊόντα με τη
  # καλύτερη διαθεσιμότητα
  return fastest_products
end

# Υπολογισμός του κόστους των προϊόντων που έχει επιλέξει ο
# αλγόριθμος επιλογής προϊόντων με βάση τη διαθεσιμότητα
def fastest_products_cost
  cost = 0
  #ap fastest_products
  fastest_products.each{ |product| cost += product.price }
  return cost
end

# Αλγόριθμος επιλογής προϊόντων με βάση τη τιμή
def cheapest_products

  # Αρχικοποίηση μεταβλητής όπου θα αποθηκευθούν τα προϊόντα 
  cheapest_products = []
  
  skus.each do |sku|
    # έλεγχος για το αν κάποιο προίόν δεν υπάρχει
    unless sku.cheapest_product.nil?
      # εισαγωγή του προϊόντος με την καλύτερη τιμή
      # στο array cheapest_products.
      cheapest_products.push(sku.cheapest_product) 
    end
  end
  
  # επιστροφή array με τα προϊόντα με τη καλύτερη τιμή
  return cheapest_products
end

# Υπολογισμός του κόστους των προϊόντων που έχει επιλέξει ο
# αλγόριθμος επιλογής προϊόντων με βάση τη τιμή
def cheapest_products_cost
  cost = 0
  cheapest_products.each{ |product| cost += product.price }
  return cost
end

# Αλγόριθμος επιλογής προϊόντων με βάση τα καταστήματα
def common_shop_products
  
  # Αρχικοποίηση μεταβλητής όπου θα αποθηκευθούν τα προϊόντα 
  products_list = []
  
  # Αρχικοποίηση βοηθητικής μεταβλητής μετρητή καταστημάτων
  shops_count = Hash.new(0)
  
  # Επαναληπτική δομή που δημιουργει μια κατάσταση με τα
  # καταστήματα στα οποία περιέχεται ο μεγαλύτερος αριθμός
  # προϊόντων που έχει βάλει ο χρήστης στη λίστα του
  skus.each do |sku|
    sku.shops.uniq.each do |shop|
      shops_count[shop] += 1
    end
  end
  
  # Ταξινόμηση της παραπάνω κατάστασης.
  # Τα καταστήματα με τα περισσότερα προϊόντα
  # βρίσκονται στην αρχή του array 
  shops_list = shops_count.to_a.sort do |x,y|
    y[1] <=> x[1]
  end
  
  # Από το array εξάγουμε τη στήλη με τα ονόματα των
  # καταστημάτων οπότε τώρα το array shops_list περιέχει
  # μια ταξινομημένη λίστα με καταστήματα 
  shops_list.collect!{|x| x[0]}
  
  skus.each do |sku|
    
    # η μεταβλητή product περιέχει ένα προϊόν του οποίου
    # το κατάστημα βρίσκεται υψηλότερα στη λίστα
    # καταστημάτων shops_list
    product= sku.product_by_shop(shops_list)
    
    # έλεγχος για το αν κάποιο προίόν δεν υπάρχει
    unless product.nil?
      # εισαγωγή του προϊόντος στο array products_list.
      products_list.push(product)
    end
  end
  
  # επιστροφή array με τα προϊόντα
  return products_list 
end

# Υπολογισμός του κόστους των προϊόντων που έχει επιλέξει ο
# αλγόριθμος επιλογής προϊόντων με βάση τα καταστήματα
def common_shop_products_cost
  cost = 0
  common_shop_products.each{ |product| cost += product.price }
  return cost
end
end
