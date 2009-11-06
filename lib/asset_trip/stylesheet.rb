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
        url_rewriter(path).rewrite(File.read(path))
      end.join("\n\n")
    end

    def compressor
      Compressor.new("css")
    end

    def url_rewriter(filesystem_path)
      public_path = AssetTrip.app_root.join("public")

      if filesystem_path.to_s.starts_with?(public_path)
        public_path = Pathname.new("/").join(filesystem_path.relative_path_from(public_path))
        UrlRewriter.new("http", public_path)
      else
        UrlRewriter.new("http")
      end
    end

    def asset_type
      :stylesheets
    end

    def extension
      ".css"
    end

  end
end
