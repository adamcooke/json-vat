module JSONVAT
  # Class FileCacheBackend is file cache adapter for CachedClient.
  #
  # @attr [String] path The path to the cache file, default is "/tmp/jsonvat.json".
  #
  class FileCacheBackend

    attr_accessor :path

    def initialize(path = "/tmp/jsonvat.json")
      @path = path
    end

    # Reads payload from the cache
    #
    # @return [String] The JSON payload
    #
    def read
      File.read(path)
    rescue Errno::ENOENT
      nil
    end

    # Writes payload to the cache
    #
    # @param [String] data The JSON payload
    #
    def write(data)
      File.open(path, 'w') { |f| f.write(data) }
      nil
    end

    # Returns time of of the last update
    #
    # @return [Time,NilClass] The time of last update or nil
    #
    def updated_at
      File.mtime(path)
    rescue Errno::ENOENT
      nil
    end

  end
end
