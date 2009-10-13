module BlobBundler
  class Compressor

    def initialize(path)
      @path = path
    end

    def compress!
      `java -jar #{jar_path} #{@path}`
    end

    def jar_path
      BlobBundler.root.join("vendor", "yuicompressor-2.4.2.jar")
    end

  end
end