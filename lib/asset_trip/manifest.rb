module AssetTrip
  class Manifest < Hash

    def path_for(key)
      md5sum = self[key]
      "/" + File.join("assets", md5sum[0..1], md5sum[2..10], key)
    end

    def [](key)
      md5sum = super
      raise UnknownAssetError.new("Can't find #{key} in the manifest") unless md5sum
      return md5sum
    end

  end
end

