require File.dirname(__FILE__) + '/test_helper.rb'

class TestMoonPhase < Test::Unit::TestCase

  def setup
    Weatherzone::Connection.instance.stubs(:request).returns( File.open("test/response/moon.xml") )
    weather = Weather.find_location("9770")
    @moon_phases = weather.moon_phases
    @moon_phase = @moon_phases.first
  end
  
  def test_should_be_a_moon_phase
    assert_kind_of MoonPhase, @moon_phase
  end

  def test_should_not_have_nil_attributes
    [:day_name, :date, :moon_phase_phase_text, :moon_phase_phase_num, :moon_phase_image_name].each do |attr_name|
      assert_not_nil @moon_phase.send(attr_name), "@moon_phase should respond to #{attr_name}"
    end
  end
  
  def test_should_be_four_phases
    assert_equal 4, @moon_phases.length
  end
  
end