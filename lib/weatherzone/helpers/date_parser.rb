module Weatherzone  
  module Helpers
    module DateParser
      def self.included(klass)
        klass.class_eval do

          def self.interpret_as_date(*methods)
            methods.each do |method_name|
              define_method method_name do
                if value = instance_variable_get("@#{method_name}")
                  Date.parse(value)
                end
              end
            end
          end

          def self.interpret_as_time(*methods)
            methods.each do |method_name|
              has_attribute :tz, :on_elements => methods
              define_method "#{method_name}_utc" do
                tz = TZInfo::Timezone.get("Australia/#{send("#{method_name}_tz")}")
                if value = instance_variable_get("@#{method_name}")
                  tz.local_to_utc(Time.parse(value))
                end
              end
              define_method method_name do
                if value = send("#{method_name}_utc")
                  tz = TZInfo::Timezone.get("Australia/#{send("#{method_name}_tz")}")
                  tz.utc_to_local value
                end
              end
            end
          end
          
        end
      end
    end
  end
end