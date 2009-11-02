module AssetTrip
  class Javascript < Asset

    def contents
      contents = joined_contents
      contents = Compressor.new("js").compress(contents)
      return contents
    end

  end
end