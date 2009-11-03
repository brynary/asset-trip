module AssetTrip
  class Stylesheet < Asset

    def contents
      contents = joined_contents
      contents = UrlRewriter.new.rewrite(contents)
      contents = Compressor.new("css").compress(contents)
      return contents
    end

    def secure_contents
      contents = joined_contents
      contents = UrlRewriter.new("https").rewrite(contents)
      contents = Compressor.new("css").compress(contents)
      return contents
    end

    def name
      "#{@name}.css"
    end

    def bundle!
      super
      secure_bundle!
    end

    def secure_bundle!
      File.open(secure_path, "w") do |file|
        file << secure_contents
      end
    end

  private

    def asset_type
      :stylesheets
    end

    def secure_name
      "#{@name}.ssl.css"
    end

    def secure_path
      dir.join(secure_name)
    end

    def extension
      ".css"
    end

  end
end
