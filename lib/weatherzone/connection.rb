require 'singleton'
require 'open-uri' 
require 'digest/md5'

module Weatherzone  
  
  class RequestFailed < Exception
    attr_reader :message, :original_exception
    def initialize(url, original_exception)
      @message            = "Failed to retreive #{url} and no cached version available"
      @original_exception = original_exception
    end
  end
  
  class Settings
    include Singleton
    attr_accessor :strip_scale_from_units, :weather_class
  end
  
  class Connection

    DEFAULT_TIMEOUT_AFTER = 5
    DEFAULT_URL = "http://webservice.theweather.com.au/ws1/wx.php"
    attr_accessor :username, :password, :url, :keygen, :logger, :timeout_after
    
    def initialize(username=nil, password=nil, keygen=nil, options={})
      @logger        = Logger.new(STDOUT)
      @logger.level  = Logger::DEBUG
      @username      = username
      @password      = password
      @url           = options[:url] || DEFAULT_URL
      @keygen        = keygen
      @logger        = options[:logger]
      @timeout_after = options[:timeout_after] || options[:timeout] || DEFAULT_TIMEOUT_AFTER
    end
    
    def self.settings
      Weatherzone::Settings.instance
    end
    
    def settings
      self.class.settings
    end
    
    def base_url
      @base_url ||= "#{self.url}?u=#{username}&k=#{password_hash}"
    end
    
    def wz_url_for(params)
      "#{base_url}#{params}"
    end
    
    def request(params)
      uri = URI.parse(wz_url_for(params))
      info("GET #{uri}")
      timeout(self.timeout_after) do
        uri.read
      end
    rescue Timeout::Error, SocketError => e
      error("webservice connection failed #{e}")
      raise RequestFailed.new(url, e)
    end
    
    def debug(message) 
      @logger.debug("[weatherzone] [DEBUG] #{message}") if @logger
    end

    def info(message)
      @logger.info("[weatherzone] [INFO] #{message}") if @logger
    end

    def error(message)
      @logger.error("[weatherzone] [ERROR] #{message}") if @logger
    end
    
    def generate_key
      date = Date.today
      key = (date.day * 2) + (date.month * 300) + ((date.year - 2000) * 170000)
    end
    
    def password_hash
      Digest::MD5.hexdigest(generate_key.to_s + self.password)
    end
   
  end
end
