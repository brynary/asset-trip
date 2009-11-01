module AssetTrip
  class Javascript < Asset

    def contents
      Compressor.new("js").compress(joined_contents)
    end

  end
end