module AssetTrip
  class StylesheetProcessor

    def process(contents)
      contents = UrlRewriter.new.rewrite(contents)
      Compressor.new("css").compress(contents)
    end

  end
end