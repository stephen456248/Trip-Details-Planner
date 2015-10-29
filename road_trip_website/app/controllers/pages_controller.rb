class PagesController < ApplicationController
  def home
  end

  def weather
  end

  def weather_input
    geocoding_api_key = ENV["GEOCODING_API_KEY"]
    @geo = HTTParty.get("https://maps.googleapis.com/maps/api/geocode/json?address=#{params["city1"].gsub(" ", "%20")}&key=" + geocoding_api_key, verify: false)
    base_url = "http://graphical.weather.gov/xml/sample_products/browser_interface/ndfdXMLclient.php?"

    lat = @geo["results"].first["geometry"]["location"]["lat"]
    lon = @geo["results"].first["geometry"]["location"]["lng"]
    time = Time.now + 4.day
    endtime = time.strftime("%Y-%m-%d")
    params = "lat=#{lat}" + "&" +
             "lon=#{lon}" + "&" +
             "end=#{endtime}T00:00:00" + "&" +
             "product=glance" +
             "iccons=true"
             
    @data = HTTParty.get(base_url + params)
  end

  def roads
  end

  def cams
    redirect_to 'http://quickmap.dot.ca.gov/'
  end
end
