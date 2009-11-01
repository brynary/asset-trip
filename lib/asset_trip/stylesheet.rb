module AssetTrip
  class Stylesheet < Asset

    def contents
      contents = UrlRewriter.new.rewrite(joined_contents)
      Compressor.new("css").compress(contents)
    end

  end
end