module AssetTrip
  class Manifest

    def initialize(md5sums = {})
      @md5sums = md5sums
    end

    def path_for(key)
      md5sum = self[key]
      "/" + File.join("assets", md5sum[0..1], md5sum[2..10], key)
    end

    def []=(key, value)
      @md5sums[key] = value
    end

    def [](key)
      unless @md5sums.has_key?(key)
        raise UnknownAssetError.new("Can't find #{key} in the manifest")
      end

      @md5sums[key]
    end

    def prune!
      Pathname.glob(AssetTrip.assets_path.join("**", "*.*")).each do |file|
        part2 = file.dirname.split.last.to_s
        part1 = file.dirname.split.first.split.last.to_s

        md5sum = part1 + part2

        if !@md5sums.has_key?(file.basename.to_s) || @md5sums[file.basename.to_s][0..10] != md5sum
          File.unlink(file)
        end
      end
    end

  end
end

