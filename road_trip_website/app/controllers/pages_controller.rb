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
    (Time.now + 5.day).strftime("%Y-%m-%d")
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
