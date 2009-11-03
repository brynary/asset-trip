module AssetTrip
  class Stylesheet < Asset

    def contents
      contents = joined_contents
      contents = url_rewriter.rewrite(contents)
      contents = Compressor.new("css").compress(contents)
      return contents
    end

    def name
      "#{@name}.css"
    end

    def ssl_stylesheet
      SSLStylesheet.new(@config, @name, @files)
    end

  private

    def url_rewriter
      UrlRewriter.new
    end

    def asset_type
      :stylesheets
    end

    def extension
      ".css"
    end

  end
end
