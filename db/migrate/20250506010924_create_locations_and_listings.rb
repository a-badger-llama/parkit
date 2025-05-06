class CreateLocationsAndListings < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.string :external_id

      t.timestamps
    end

    create_table :listings do |t|
      t.integer :location_id
      t.string :external_id
      t.integer :length
      t.integer :width
      t.integer :price_in_cents

      t.timestamps
    end
  end
end
