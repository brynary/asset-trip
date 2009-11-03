module AssetTrip
  class SSLStylesheet < Stylesheet

    def name
      "#{@name}.ssl.css"
    end

  private

    def url_rewriter(path)
      UrlRewriter.new("https", path)
    end

  end
end
