module Weatherzone
  class DailyObservation < Weatherzone::Resource
    include Weatherzone::Helpers::Units

    has_elements :day_name, :date, :temp_min_c, :temp_max_c, :rainfall_mm
    has_attribute :units, :on_elements => [:temp_min_c, :temp_max_c, :rainfall_mm]
    has_attribute :period, :on_elements => :rainfall_mm

    temperature :temp_min_c, :temp_max_c
    value_plus_unit_readers :rainfall_mm
  end
end