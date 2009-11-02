module AssetTrip
  module Helper

    def javascript_include_asset(*sources)
      sources.map! { |source| _asset_trip_url(source, ".js") }
      sources.collect { |source| javascript_include_tag(source) }.join("\n")
    end

    def stylesheet_link_asset(*sources)
      options = sources.extract_options!
      sources.map! { |source| _asset_trip_url(source, ".css") }
      sources.collect { |source| stylesheet_link_tag(source, options) }.join("\n")
    end

    def rewrite_asset_path(source)
      if source =~ /assets/
        source
      else
        super
      end
    end

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