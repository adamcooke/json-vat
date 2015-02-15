require 'net/http'
require 'uri'
require 'json'
require 'json_vat/country'
require 'json_vat/file_cache_backend'

module JSONVAT

  class << self

    def perform_caching?
      @perform_caching != false
    end

    def cache_backend
      @cache_backend ||= FileCacheBackend.new
    end

    attr_writer :cache_backend
    attr_writer :perform_caching

    def download
      Net::HTTP.get_response(URI.parse('http://jsonvat.com')).body
    end

    def cache
      content = self.download
      self.cache_backend.write(content)
      content
    end

    def rates_through_cache
      if self.perform_caching?
        self.cache_backend.read || self.cache
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
