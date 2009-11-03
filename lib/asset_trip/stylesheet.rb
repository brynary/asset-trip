module AssetTrip
  class Stylesheet < Asset

    def name
      "#{@name}.css"
    end

    def ssl_stylesheet
      SSLStylesheet.new(@config, @name, @files)
    end

  private

    def joined_contents
      paths.map do |path|
        url_rewriter.rewrite(File.read(path))
      end.join("\n\n")
    end

    def compressor
      Compressor.new("css")
    end

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
