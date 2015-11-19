class Forecast
  attr_reader :weather, :city
  def initialize(weather, city)
  	@city = city
  	@weather = weather
    parameters = @weather["dwml"]["data"]["parameters"]
    @highs = Array(parameters["temperature"][0]["value"])
    @lows = Array(parameters["temperature"][1]["value"])
    @icons = Array(parameters["conditions_icon"]["icon_link"])
    
  end

  def periods

      [{icon: @icons[0],  temp: @highs[0], type: "high"},
      {icon: @icons[4],  temp: @lows[0], type: "low"},
      {icon: @icons[8],  temp: @highs[1], type: "high"},
      {icon: @icons[12], temp: @lows[1], type: "low"},
      {icon: @icons[16], temp: @highs[2], type: "high"},
      {icon: @icons[20], temp: @lows[2], type: "low"},
      {icon: @icons[24], temp: @highs[3], type: "high"},
      {icon: @icons[26], temp: @lows[3], type: "low"}]
  end

  def eql?(other)
  	city == other.city
  end

  def hash
  	city.hash
  end
end