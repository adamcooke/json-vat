module JSONVAT
  class MemcacheBackend

    attr_accessor :key, :client, :ttl

    def initialize(key = 'JSONVAT', ttl = 86400, client = nil)
      @key = key
      @ttl = ttl

      client ||= Dalli::Client.new
      @client = client
    end

    def read
      @client.get @key
    end

    def write(data)
      @client.set @key, data, @ttl
    end

  end
end
