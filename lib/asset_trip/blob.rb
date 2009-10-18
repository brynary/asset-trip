require "digest"

module AssetTrip
  class Blob
    extend Memoizable

    def initialize(blob_config)
      @blob_config = blob_config
    end

    def bundle!
      FileUtils.mkdir_p(File.dirname(path))

      File.open(path, "w") do |file|
        file << contents
      end
    end

    def name
      @blob_config.name
    end

    def md5sum
      @md5sum ||= Digest::MD5.hexdigest(contents)
    end

  private

    def contents
      @blob_config.paths.map do |path|
        contents = File.read(path)
        contents = UrlRewriter.new(path).rewrite(contents)
        contents = Compressor.new(path).compress(contents)
      end.join
    end
    memoize :contents

    def path
      dir.join(@blob_config.name)
    end

    def dir
      part1 = md5sum[0..1]
      part2 = md5sum[2..10]
      @blob_config.blob_path.join(part1, part2)
    end

  end
end