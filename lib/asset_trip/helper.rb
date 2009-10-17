module AssetTrip
  module Helper

    def javascript_include_blob(*sources)
      options = sources.extract_options!
      sources.map! { |source| _asset_trip_url(source) }
      sources.collect { |source| javascript_include_tag(source, options) }.join("\n")
    end

    def rewrite_asset_path(source)
      if source =~ /blobs/
        source
      else
        super
      end
    end

    def _asset_trip_url(source)
      key = File.basename(source.to_s, ".js") + ".js"
      md5sum = AssetTrip.manifest[key]

      part1 = md5sum[0..1]
      part2 = md5sum[2..10]

      "/" + File.join("blobs", part1, part2, key)
    end

  end
end