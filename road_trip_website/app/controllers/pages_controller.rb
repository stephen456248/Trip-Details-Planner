class PagesController < ApplicationController
  def home
    session[:dummy_data] = 3
  end

  def weather
  end

  def weather_input
    if session[:weather]
      @data = session[:weather][:data]
      @geo = session[:weather][:geo]
    else
      session[:weather] = {}
      geocoding_api_key = ENV["GEOCODING_API_KEY"]
      google_url = "https://maps.googleapis.com/maps/api/geocode/json?"
      google_params = "address=" + params["city1"].gsub(" ", "%20") + "&" +
                      "key=" + geocoding_api_key
      session[:weather][:geo] = @geo = HTTParty.get(google_url + google_params, verify: false)
      weather_url = "http://graphical.weather.gov/xml/sample_products/browser_interface/ndfdXMLclient.php?"

      lat = @geo["results"].first["geometry"]["location"]["lat"]
      lon = @geo["results"].first["geometry"]["location"]["lng"]
      time = Time.now + 4.day
      endtime = time.strftime("%Y-%m-%d")
      weather_params = "lat=#{lat}" + "&" +
               "lon=#{lon}" + "&" +
               "end=#{endtime}T00:00:00" + "&" +
               "product=glance"
               
      session[:weather][:data] = @data = HTTParty.get(weather_url + weather_params)
    end
  end

  def roads
  end

  def cams
    redirect_to 'http://quickmap.dot.ca.gov/'
  end
end
