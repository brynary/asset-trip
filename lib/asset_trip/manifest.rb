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

  end
end

