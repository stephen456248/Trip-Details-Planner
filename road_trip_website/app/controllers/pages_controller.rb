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
    weather_url = "http://graphical.weather.gov/xml/sample_products/browser_interface/ndfdXMLclient.php?"

    lat = @geo["results"].first["geometry"]["location"]["lat"]
    lon = @geo["results"].first["geometry"]["location"]["lng"]
    time = Time.now + 4.day
    endtime = time.strftime("%Y-%m-%d")
    weather_params = "lat=#{lat}" + "&" +
             "lon=#{lon}" + "&" +
             "end=#{endtime}T00:00:00" + "&" +
             "product=glance"
             
    @data = HTTParty.get(weather_url + weather_params)
    session[:weather][:data] = @data.parsed_response
  end
end
