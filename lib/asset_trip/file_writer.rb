module AssetTrip
  class FileWriter

    def initialize(path)
      @path = path
    end

    def write!(contents)
      FileUtils.mkdir_p(File.dirname(@path))

      File.open(@path, "w") do |file|
        file << contents
      end
    end

  end
end
