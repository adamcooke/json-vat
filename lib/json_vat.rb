require_relative 'json_vat/plain_client'
require_relative 'json_vat/cached_client'
require_relative 'json_vat/file_cache_backend'

module JSONVAT

  class Configuration

    attr_accessor :perform_caching,
                  :cache_backend,
                  :host,
                  :client

    def initialize
      @perform_caching = true
      @cache_backend = FileCacheBackend.new('/tmp/jsonvat.json')
      @host = 'http://jsonvat.com'
      @client = nil
    end
  end

  class << self

    def configure
      @configuration = Configuration.new
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def client
      @client ||=
        if configuration.client
          configuration.client
        elsif configuration.perform_caching
          CachedClient.new(configuration.host, configuration.cache_backend)
        else
          PlainClient.new(configuration.host)
        end
    end

    attr_writer :client

    # Deprecate old configuration methods
    %w[cache_backend perform_caching host].each do |param|
      define_method("#{param}=") do |val|
        warn "[DEPRECATION] `JSONVAT.#{param}=` is deprecated. Please use `JSONVAT.configure` block instead."
        configuration.send("#{param}=", val)
      end
    end

    def download
      client.download
    end

    def cache
      raise "#{client.class} does not support `cache` method" unless client.respond_to?(:cache)
      client.cache
    end

    def rates
      client.rates
    end

    def reset_rates
      client.reset_rates
    end

    def country(country)
      client.country(country)
    end

    def [](country)
      client.country(country)
    end

  end

end
