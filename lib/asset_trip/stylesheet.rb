module AssetTrip
  class Stylesheet < Asset

    def contents
      contents = joined_contents
      contents = UrlRewriter.new.rewrite(contents)
      contents = Compressor.new("css").compress(contents)
      return contents
    end

    def name
      "#{@name}.css"
    end

  private

    def load_path
      @config.css_load_path
    end

    def extension
      ".css"
    end
      
  end
end