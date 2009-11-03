module AssetTrip
  module Helper

    def javascript_include_asset(*sources)
      _javascripts_for_sources(sources).map do |javascript|
        javascript_include_tag(javascript)
      end.join("\n")
    end

    def stylesheet_link_asset(*sources)
      options = sources.extract_options!

      _stylesheets_for_sources(sources).map do |stylesheet|
        stylesheet_link_tag(stylesheet, options)
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

    def _stylesheets_for_sources(sources)
      sources.map { |source| _stylesheets_for_source(source) }.flatten
    end

    def _javascripts_for_sources(sources)
      sources.map { |source| _javascripts_for_source(source) }.flatten
    end

    def _stylesheets_for_source(source)
      if AssetTrip.bundle
        _stylesheet_manifest_url(source)
      else
        _unbundled_stylesheet_urls(source)
      end
    end

    def _javascripts_for_source(source)
      if AssetTrip.bundle
        AssetTrip.manifest.path_for(_source_with_extension(source, ".js"))
      else
        _unbundled_javascript_urls(source)
      end
    end

    def _unbundled_stylesheet_urls(source)
      asset = AssetTrip.config.assets_hash[_source_with_extension(source, ".css")]

      asset.files.map do |file|
        _unbundled_asset_url(:stylesheets, file)
      end
    end

    def _unbundled_javascript_urls(source)
      asset = AssetTrip.config.assets_hash[_source_with_extension(source, ".js")]

      asset.files.map do |file|
        _unbundled_asset_url(:javascripts, file)
      end
    end

    def _unbundled_asset_url(asset_type, file)
      "#{request.protocol}#{request.host}/__asset_trip__/#{asset_type}/#{file}"
    end

    def _stylesheet_manifest_url(source)
      source_with_extension = _source_with_extension(source, ".css")
      source_with_extension.gsub!(/.css$/, ".ssl.css") if request.ssl?
      AssetTrip.manifest.path_for(source_with_extension)
    end

    def _source_with_extension(source, extension)
      File.basename(source.to_s, extension) + extension
    end

  end
end
