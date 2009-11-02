module AssetTrip
  module Helper

    def javascript_include_asset(*sources)
      sources.map do |source|
        javascript_include_tag(_asset_trip_url(source, ".js"))
      end.join("\n")
    end

    def stylesheet_link_asset(*sources)
      options = sources.extract_options!

      sources.map do |source|
        stylesheet_link_tag(_asset_trip_url(source, ".css"), options)
      end.join("\n")
    end

    def rewrite_asset_path(source)
      if source =~ /assets/
        source
      else
        super
      end
    end

  private

    def _asset_trip_url(source, extension)
      key = File.basename(source.to_s, extension) + extension
      md5sum = AssetTrip.manifest[key]

      raise UnknownAssetError.new("Can't find #{key} in the manifest") unless md5sum

      part1 = md5sum[0..1]
      part2 = md5sum[2..10]

      "/" + File.join("assets", part1, part2, key)
    end

  end
end