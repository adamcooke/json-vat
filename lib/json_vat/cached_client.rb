require_relative 'plain_client'

module JSONVAT

  # Class CachedClient reads data from the cache (file cache by default) and
  # memoizes the result, cache has to be manually refreshed.
  #
  class CachedClient < PlainClient

    def initialize(host = nil, cache_backend = nil)
      super(host)
      @cache_backend = cache_backend || JSONVAT.configuration.cache_backend
      @cache_updated_at = cache_backend.updated_at
    end

    def data
      JSON.parse(cache_read)
    end

    def rates
      reset_rates unless cache_update?
      super
    end

    def reset_rates
      @cache_updated_at = cache_backend.updated_at
      super
    end

    def cache
      cache_refresh
    end

  private

    attr_reader :cache_backend, :cache_updated_at

    def cache_update?
      cache_updated_at == cache_backend.updated_at
    end

    def cache_read
      cache_backend.read || cache_refresh
    end

    def cache_refresh
      content = download
      cache_backend.write(content)
      reset_rates
      content
    end

  end

end
