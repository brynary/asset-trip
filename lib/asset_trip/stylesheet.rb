module AssetTrip
  class Stylesheet < Asset

    def contents
      contents = joined_contents
      contents = UrlRewriter.new.rewrite(contents)
      contents = Compressor.new("css").compress(contents)
      return contents
    end

  end
end