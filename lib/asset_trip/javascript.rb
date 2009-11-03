module AssetTrip
  class Javascript < Asset

    def contents
      contents = joined_contents
      contents = Compressor.new("js").compress(contents)
      return contents
    end

    def name
      "#{@name}.js"
    end

  private

    def asset_type
      :javascripts
    end

    def extension
      ".js"
    end

  end
end
