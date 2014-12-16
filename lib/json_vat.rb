require 'net/http'
require 'uri'
require 'json'
require 'json_vat/country'

module JSONVAT

  class << self

    def cache_path
      @cache_file ||= '/tmp/jsonvat.json'
    end

    attr_writer :cache_path

    def download
      Net::HTTP.get_response(URI.parse('http://jsonvat.com')).body
    end

    def cache
      content = self.download
      File.open(self.cache_path, 'w') { |f| f.write(content) }
      content
    end

    def rates_through_cache
      if self.cache_path.is_a?(String)
        File.exist?(self.cache_path) ? File.read(self.cache_path) : self.cache
      else
        self.download
      end
    end

    def rates
      @rates ||= JSON.parse(self.rates_through_cache)['rates'].map do |country|
        JSONVAT::Country.new(country)
      end
    end

    def country(country)
      self.rates.select { |r| r.country_code == country.to_s.upcase }.first
    end

    def [](country)
      country(country)
    end

  end


end
