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

    def invalid?
      modified_time = current_modified_time

      if modified_time != @last_modified_time
        @last_modified_time = modified_time
        true
      else
        false
      end
    end

    private

    def current_modified_time
      File.stat(path).mtime.to_i
    rescue Errno::ENOENT
      0
    end
  end
end
