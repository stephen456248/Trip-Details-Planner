class PagesController < ApplicationController
  def home
    session[:dummy_data] = 3
  end

  def weather
  end

  def weather_input
    if session[:weather] && params["city1"].eql?(session[:weather][:last_query])
      @data = session[:weather][:data]
      @geo = session[:weather][:geo]
    else
      session[:weather] = {}
      session[:weather][:last_query] = params["city1"]
      geocoding_api_query!
      weather_api_query!
    end
  end

  def roads
  end

  def cams
    redirect_to 'http://quickmap.dot.ca.gov/'
  end

  def output
    if session[:weather]
      highs = session[:weather][:highs]
      lows = session[:weather][:lows]
      icons = session[:weather][:icons]
    else
      highs = [0]*4
      lows = [0]*4
      icons = [""]*27
    end
    # [[i0, h0], [i4,l0]...[i26,l3]]
    @days = []
    #if blah
    #  @days[0] = {icon: icons[0],  temp: lows[0], type: "low"}
    #  @days[1] = {icon: icons[4],  temp: highs[0], type: "high"}
    #  @days[2] = {icon: icons[8],  temp: lows[1], type: "low"}
    #  @days[3] = {icon: icons[12], temp: highs[1], type: "high"}
    #  @days[4] = {icon: icons[16], temp: lows[2], type: "low"}
    #  @days[5] = {icon: icons[20], temp: highs[2], type: "high"}
    #  @days[6] = {icon: icons[24], temp: lows[3], type: "low"}
    #  @days[7] = {icon: icons[26], temp: highs[3], type: "high"}
    #else
      @days[0] = {icon: icons[0],  temp: highs[0], type: "high"}
      @days[1] = {icon: icons[4],  temp: lows[0], type: "low"}
      @days[2] = {icon: icons[8],  temp: highs[1], type: "high"}
      @days[3] = {icon: icons[12], temp: lows[1], type: "low"}
      @days[4] = {icon: icons[16], temp: highs[2], type: "high"}
      @days[5] = {icon: icons[20], temp: lows[2], type: "low"}
      @days[6] = {icon: icons[24], temp: highs[3], type: "high"}
      @days[7] = {icon: icons[26], temp: lows[3], type: "low"}
    #end
    if params[:road]
      session[:roads] ||= []
      url_base = "http://www.dot.ca.gov/hq/roadinfo/"
      @road = HTTParty.get(url_base + params[:road])
      session[:roads] << @road.parsed_response.gsub(/\r\n/, "<br>")
      session[:roads] = session[:roads].uniq.last 4
    else
      if session[:roads].nil? || session[:roads].empty?
        session[:roads] = []
      end
    end

  end

  private

  def geocoding_api_query!
    geocoding_api_key = ENV["GEOCODING_API_KEY"]
    google_url = "https://maps.googleapis.com/maps/api/geocode/json?"
    google_params = "address=" + params["city1"].gsub(" ", "%20") + "&" +
                    "key=" + geocoding_api_key
    @geo = HTTParty.get(google_url + google_params, verify: false)
    session[:weather][:geo] = @geo.parsed_response
  end

  def weather_api_query!
    @data = HTTParty.get(weather_url + weather_params)
    session[:weather][:data] = @data.parsed_response
    parameters = session[:weather][:data]["dwml"]["data"]["parameters"]
    session[:weather][:highs] = Array(parameters["temperature"][0]["value"])
    session[:weather][:lows] = Array(parameters["temperature"][1]["value"])
    session[:weather][:icons] = Array(parameters["conditions_icon"]["icon_link"])
  end

  def lat
    @geo["results"].first["geometry"]["location"]["lat"]
  end

  def lon
    @geo["results"].first["geometry"]["location"]["lng"]
  end

  def endtime
    (Time.now + 8.day).strftime("%Y-%m-%d")
  end

  def weather_url
    "http://graphical.weather.gov/xml/sample_products/browser_interface/ndfdXMLclient.php?"
  end

  def weather_params
    "lat=#{lat}" + "&" +
    "lon=#{lon}" + "&" +
    "end=#{endtime}T00:00:00" + "&" +
    "product=glance"
  end


end
