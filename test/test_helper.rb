require 'test/unit'
require File.dirname(__FILE__) + '/../lib/weatherzone'

class Test::Unit::TestCase

  # Set three instance variables on the connection instance to test the service:
  #   1) Your weatherzone username
  #   2) Your weatherzone password
  #   3) A method for generating a valid weatherzone key
  def create_connection
    @connection          = Weatherzone::Connection.instance
    @connection.username = "<your-username>"
    @connection.password = "<your-password>"
    @connection.keygen = lambda do
      "<your-sekret-keygen>"
    end
    verify_connection_parameters
  end

  # We don't want to attempt to run any tests unless these parameters have been set
  def verify_connection_parameters
    assert_not_equal "<your-username>", @connection.username, "You haven't set a username"
    assert_not_equal "<your-password>", @connection.password, "You haven't set a password"
    assert_not_equal "<your-sekret-keygen>", @connection.key, "You haven't set a keygen"
  end

end
