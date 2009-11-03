module AssetTrip
  class SSLStylesheet < Stylesheet

    def bundle!
      FileUtils.mkdir_p(File.dirname(path))

      File.open(path, "w") do |file|
        file << contents
      end
    end

    def name
      "#{@name}.ssl.css"
    end

  private

    def url_rewriter
      UrlRewriter.new("https")
    end

  end
end
