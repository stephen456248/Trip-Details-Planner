class PagesController < ApplicationController
  def home
  end

  def weather
  end

  def weather_input
    base_url = "http://graphical.weather.gov/xml/sample_products/browser_interface/ndfdXMLclient.php?"

    lat = 35.37
    lon = -119.02
    time = Time.now + 1.day
    endtime = time.strftime("%Y-%m-%d")
    params = "lat=#{lat}" + "&" +
             "lon=#{lon}" + "&" +
             "end=#{endtime}T00:00:00" + "&" +
             "product=time-series"
             
    @data = HTTParty.get(base_url + params)
  end

  def roads
  end

  def cams
    redirect_to 'http://quickmap.dot.ca.gov/'
  end
end
