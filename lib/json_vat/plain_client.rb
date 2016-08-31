require 'net/http'
require 'uri'
require 'json'
require_relative 'country'

module JSONVAT

  class PlainClient

    def initialize(host = nil)
      @host = host || 'http://jsonvat.com'
    end

    def download
      Net::HTTP.get_response(URI.parse(host)).body
    end

    def data
      JSON.parse(download)
    end

    def rates
      @rates ||= data['rates'].map do |country|
        Country.new(country)
      end
    end

    def reset_rates
      @rates = nil
    end

    def country(country)
      code = country.to_s.upcase

      # Fix ISO-3166-1-alpha2 exceptions
      if code == 'UK' then code = 'GB' end
      if code == 'EL' then code = 'GR' end

      rates.find { |r| r.country_code == code }
    end

    def [](country)
      country(country)
    end

  protected

    attr_reader :host

  end

end
