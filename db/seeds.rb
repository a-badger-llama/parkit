# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

listings = JSON.parse(File.read(Rails.root.join("db", "fixtures", "listings.json")))

listings.each do |listing|
  location = Location.find_or_create_by!(external_id: listing["location_id"])
  location.listings.find_or_create_by!(external_id: listing["id"], length: listing["length"], width: listing["width"], price_in_cents: listing["price_in_cents"])
end
