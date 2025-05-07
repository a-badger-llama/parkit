require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test "successful search returns locations sorted by price" do
    post "/", params: [
                        { length: 10, quantity: 2 },
                        { length: 20, quantity: 2 }
                      ].to_json, headers: { "Content-Type": "application/json" }

    assert_response :success

    expected = [
      { location_id:          "loc2",
        listing_ids:          ["loc2_list3"],
        total_price_in_cents: 400
      },
      { location_id:          "loc1",
        listing_ids:          ["loc1_list1", "loc1_list2", "loc1_list4"],
        total_price_in_cents: 450
      },
      {
        location_id:          "loc3",
        listing_ids:          ["loc3_list3"],
        total_price_in_cents: 500
      }
    ]

    assert_equal expected, JSON.parse(response.body, symbolize_names: true)
  end

  test "returns empty array when no locations can accommodate vehicles" do
    post "/", params: [{ length: 100, quantity: 1 }].to_json, headers: { "Content-Type": "application/json" }

    assert_response :success
    assert_empty JSON.parse(response.body)
  end

  test "returns bad request for malformed json" do
    post "/", params: "invalid json".to_json, headers: { "Content-Type": "application/json" }

    assert_response :bad_request
  end

  test "returns bad request for missing required parameters" do
    post "/", params: [{ quantity: 1 }].to_json, headers: { "Content-Type": "application/json" }

    assert_response :bad_request
  end
end
