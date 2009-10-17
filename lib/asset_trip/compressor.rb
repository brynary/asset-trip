require "systemu"

module AssetTrip

  class Compressor

    def initialize(path)
      @path = path
    end

    def compress!
      status, stdout, stderr = systemu("java -jar #{jar_path} #{@path}")
      raise CompressorError.new(stderr) unless status.success?
      return stdout
    end

    def jar_path
      AssetTrip.root.join("vendor", "yuicompressor-2.4.2.jar")
    end

  end
end