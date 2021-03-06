require File.dirname(__FILE__) + '/test_helper.rb'

class TestWeather < Test::Unit::TestCase

  def setup
    super
    @connection.stubs(:request).returns( File.open("test/response/everything.xml")  )
    @weather = Weatherzone::Weather.find_by_location_code(@connection, "9770")
  end
  
  def test_should_be_an_instance_of_weather
    assert_kind_of Weatherzone::Weather, @weather
  end

  def test_should_have_countries
    assert @weather.countries.any?
  end
  
  def test_countries_should_be_countries
    assert_kind_of Weatherzone::Country, @weather.countries.first
  end
  
end
