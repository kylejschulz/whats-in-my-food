class FoodService
  def results(q)
    response = conn.get("/fdc/v1/foods/search?") do |faraday|
      faraday.params['query'] = q[:q]
    end
    parsed = JSON.parse(response.body, symbolize_names: true)
    @foods = parsed[:foods].first(10).map do |data|
      Food.new(data)
    end
  end

  def total_results(q)
    response = conn.get("/fdc/v1/foods/search?") do |faraday|
      faraday.params['query'] = q[:q]
    end
    JSON.parse(response.body, symbolize_names: true)[:totalHits]
  end

  private
  def conn
    conn = Faraday.new(url: "https://api.nal.usda.gov") do |faraday|
      faraday.params["api_key"] = ENV['usda_foods_api']
    end
  end
end