class ApplicationController < ActionController::API
  def search
    render json: [
                   {
                     "location_id": "abc123",
                     "listing_ids": ["def456", "ghi789", "jkl012"],
                     "total_price_in_cents": 300
                   },
                   {
                     "location_id": "mno345",
                     "listing_ids": ["pqr678", "stu901"],
                     "total_price_in_cents": 305
                   }
                 ]
  end
end
