module AssetTrip
  class LoadPath

    def initialize
      @paths = []
    end

    def <<(path)
      @paths << Pathname.new(path)
    end

    def resolve(file)
      file_paths = @paths.map do |path|
        path.join(file).expand_path
      end

      result = file_paths.detect do |file_path|
        File.exist?(file_path)
      end
      
      if result
        return result
      else
        raise "Could not find #{file} in paths: #{@paths.inspect}"
      end
    end

  end
end