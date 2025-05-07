class ApplicationController < ActionController::API
  def search
    begin
      vehicle_lengths = vehicle_params.flat_map do |param|
        # I spent too long messing with strong params :/
        raise ActionController::ParameterMissing.new("missing required param, length or quantity") if param["length"].nil? || param["quantity"].nil?

        Array.new(param["quantity"], param["length"])
      end

      response = Location.possible_locations(vehicle_lengths)

      render json: response
    rescue ActionController::ParameterMissing => e
      render status: :bad_request, json: { message: e.message }
    end
  end

  private

  def vehicle_params
    params.expect(_json: [[:length, :quantity]])
  end
end
