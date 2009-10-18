require "digest"

module AssetTrip
  class Asset
    extend Memoizable

    def initialize(asset_config)
      @asset_config = asset_config
    end

    def bundle!
      FileUtils.mkdir_p(File.dirname(path))

      File.open(path, "w") do |file|
        file << contents
      end
    end

    def name
      @asset_config.name
    end

    def md5sum
      @md5sum ||= Digest::MD5.hexdigest(contents)
    end

  private

    def contents
      @asset_config.paths.map do |path|
        contents = File.read(path)
        contents = UrlRewriter.new.rewrite(contents)
        contents = Compressor.new(path).compress(contents)
      end.join
    end
    memoize :contents

    def path
      dir.join(@asset_config.name)
    end

    def dir
      part1 = md5sum[0..1]
      part2 = md5sum[2..10]
      @asset_config.assets_path.join(part1, part2)
    end

  end
end