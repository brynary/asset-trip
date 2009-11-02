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
      AssetTrip.manifest.path_for(_source_with_extension(source, extension))
    end

    def _source_with_extension(source, extension)
      File.basename(source.to_s, extension) + extension
    end

  end
end