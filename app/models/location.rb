class Location < ApplicationRecord
  has_many :listings

  WIDTH_OFFSET = 10

  def self.possible_locations(vehicle_lengths)
    return [] if vehicle_lengths.compact.empty?

    locations = includes(:listings).map do |location|
      if best_combination = location.best_price_combination(vehicle_lengths)
        {
          location_id:          location.external_id,
          listing_ids:          best_combination.map(&:external_id),
          total_price_in_cents: best_combination.sum(&:price_in_cents)
        }
      end
    end

    locations.compact.sort_by { |location| location[:total_price_in_cents] }
  end

  def best_price_combination(vehicle_lengths)
    listing_combinations_by_price.find { |combo| can_store_all_vehicles?(combo, vehicle_lengths) }
  end

  def listing_combinations_by_price
    (1..listings.size).flat_map { |size| listings.to_a.combination(size).to_a }.sort_by { |combo| combo.sum(&:price_in_cents) }
  end

  def can_store_all_vehicles?(listing_combination, vehicle_lengths)
    lanes           = listing_combination.map { |l| Array.new(l.width / WIDTH_OFFSET, l.length) }.flatten
    vehicle_lengths = vehicle_lengths.sort.reverse

    vehicle_lengths.all? do |vehicle_length|
      fit_vehicle_into_lanes(lanes, vehicle_length)
    end
  end

  def fit_vehicle_into_lanes(lanes, vehicle_length)
    lanes.each_with_index do |lane, i|
      if lane >= vehicle_length
        lanes[i] -= vehicle_length

        return true
      end
    end

    false
  end
end
