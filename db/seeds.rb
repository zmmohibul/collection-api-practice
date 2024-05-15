# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# User.destroy_all
#
# User.create(username: "admin", password: "admin", role: "admin")
# User.create(username: "mohib", password: "mohib", role: "user")

# Collection.destroy_all

book_collection = Collection.new(name: "books", description: "Collection of books")

auth_ifd = ItemFieldDescription.new(name: "Author", data_type: "string")
pub_date_ifd = ItemFieldDescription.new(name: "Publication Date", data_type: "date")
page_count_ifd = ItemFieldDescription.new(name: "Page Count", data_type: "int")

book_collection.item_field_descriptions << [auth_ifd, pub_date_ifd, page_count_ifd]
book_collection.save


kitten_collection = Collection.new(name: "kittens", description: "Collection of cats")

breed_ifd = ItemFieldDescription.create(name: "Breed", data_type: "string", collection_id: 2)
weight_ifd = ItemFieldDescription.create(name: "Weight", data_type: "int", collection_id: 2)
dob_ifd = ItemFieldDescription.create(name: "Date of Birth", data_type: "date", collection_id: 2)

kitten_collection.item_field_descriptions << [breed_ifd, weight_ifd, dob_ifd]
kitten_collection.save
