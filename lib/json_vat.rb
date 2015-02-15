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

    def host
      @host ||= 'http://jsonvat.com'
    end

    attr_writer :cache_backend
    attr_writer :perform_caching
    attr_writer :host

    def download
      Net::HTTP.get_response(URI.parse(self.host)).body
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
      code = country.to_s.upcase

      # Fix ISO-3166-1-alpha2 exceptions
      if code == 'UK' then code = 'GB' end
      if code == 'EL' then code = 'GR' end

      self.rates.find { |r| r.country_code == code }
    end

    def [](country)
      country(country)
    end

  end

end
