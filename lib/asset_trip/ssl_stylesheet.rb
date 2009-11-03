module AssetTrip
  class SSLStylesheet < Stylesheet

    def name
      "#{@name}.ssl.css"
    end

  private

    def url_rewriter
      UrlRewriter.new("https")
    end

  end
end
