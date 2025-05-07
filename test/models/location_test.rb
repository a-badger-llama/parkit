require "test_helper"

class LocationTest < ActiveSupport::TestCase
  # returns every possible location that can store vehicles of the given lengths
  # returns the least expensive combination of listings per location
  # returns only one result for each location
  # sorted by least total price in cents, ascending
  test "possible_locations returns all locations" do
    vehicles = [10, 10, 20, 20, 10, 10]

    actual   = Location.possible_locations(vehicles)
    expected = [
      {
        location_id:          "loc3",
        listing_ids:          ["loc3_list3"],
        total_price_in_cents: 500
      },
      {
        location_id:          "loc2",
        listing_ids:          ["loc2_list2", "loc2_list3"],
        total_price_in_cents: 700
      }
    ]

    assert_equal expected, actual
  end

  test "best_price_combination returns the cheapest combination" do
    actual   = locations(:loc1).best_price_combination([10, 10, 10])
    expected = [listings(:loc1_list4_250)]

    assert_equal expected, actual
  end

  test "best_price_combination returns nil if no combination can be found" do
    actual   = locations(:loc1).best_price_combination([25])

    assert_nil actual
  end

  test "listing_combinations_by_price returns all combinations sorted by total price" do
    actual   = locations(:loc2).listing_combinations_by_price
    expected = [
      [listings(:loc2_list1_250)],
      [listings(:loc2_list2_300)],
      [listings(:loc2_list3_400)],
      [listings(:loc2_list1_250), listings(:loc2_list2_300)],
      [listings(:loc2_list1_250), listings(:loc2_list3_400)],
      [listings(:loc2_list2_300), listings(:loc2_list3_400)],
      [listings(:loc2_list1_250), listings(:loc2_list2_300), listings(:loc2_list3_400)]
    ]

    failed_message = "Expected #{expected.map { |combo| combo.map(&:external_id) }}," \
      "got #{actual.map { |combo| combo.map(&:external_id) }}"

    assert_equal expected, actual, failed_message
  end

  test "can_store_all_vehicles? returns true if all vehicles can be stored" do
    listing_combination = [listings(:loc1_list1_100), listings(:loc1_list2_100), listings(:loc1_list3_100)]
    vehicle_lengths     = [10, 10, 10]

    assert locations(:loc1).can_store_all_vehicles?(listing_combination, vehicle_lengths)
  end

  test "can_store_all_vehicles? returns false if not all vehicles can be stored" do
    listing_combination = [listings(:loc1_list1_100), listings(:loc1_list2_100)]
    vehicle_lengths     = [10, 10, 10]

    refute locations(:loc1).can_store_all_vehicles?(listing_combination, vehicle_lengths)
  end

  test "fit_vehicle_into_lanes returns true if vehicle fits into a lane" do
    lanes          = [10, 10, 10]
    vehicle_length = 10

    assert locations(:loc1).fit_vehicle_into_lanes(lanes, vehicle_length)
  end

  test "fit_vehicle_into_lanes returns false if vehicle does not fit into a lane" do
    lanes          = [10, 10, 10]
    vehicle_length = 20

    refute locations(:loc1).fit_vehicle_into_lanes(lanes, vehicle_length)
  end
end
