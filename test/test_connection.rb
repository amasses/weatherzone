require File.dirname(__FILE__) + '/test_helper.rb'

class TestConnection < Test::Unit::TestCase

  def setup
    @connection = Weatherzone::Connection.new("username", "password", nil, :url => "http://ws1.theweather.com.au/")
  end

  def test_should_set_username
    assert_equal "username", @connection.username
  end

  def test_should_set_password
    assert_equal "password", @connection.password
  end

  def test_should_provide_base_url
    Timecop.freeze(Time.utc(2011, 01, 01)) do
      key = 1870302 # On 20110101 the key should be this value
      hash = Digest::MD5.hexdigest "#{key}password"
      assert_equal "http://ws1.theweather.com.au/?u=username&k=#{hash}", @connection.base_url
    end
  end
  
end
