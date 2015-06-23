# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create(name: "efi", full_name: "Έφη", password: "efi", password_confirmation: "efi")

User.create(name: "anastasia", full_name: "Αναστασία", password: 'anastasia', password_confirmation: "anastasia")

sku_ids = %w( 94692 6202137 3854216 5384430 90190 3711939 2567463 5307730 5071785 5340213 2069899 3216685)

sku_ids.each { |id|  Sku.fetch id }
