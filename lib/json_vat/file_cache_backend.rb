module JSONVAT
  class FileCacheBackend

    attr_accessor :path

    def initialize(path = "/tmp/jsonvat.json")
      @path = path
    end

    def read
      File.read(self.path)
    rescue Errno::ENOENT
      nil
    end

    def write(data)
      File.open(self.path, 'w') { |f| f.write(data) }
    end

  end
end
