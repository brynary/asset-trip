module AssetTrip
  class JavascriptProcessor

    def process(contents)
      Compressor.new("js").compress(contents)
    end

  end
end