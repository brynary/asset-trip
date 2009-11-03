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
        _manifest_url(source, ".css")
      else
        _unbundled_stylesheet_urls(source)
      end
    end

    def _javascripts_for_source(source)
      if AssetTrip.bundle
        _manifest_url(source, ".js")
      else
        _unbundled_javascript_urls(source)
      end
    end

    def _unbundled_stylesheet_urls(source)
      asset = AssetTrip.config.assets_hash[_source_with_extension(source, ".css")]

      asset.files.map do |file|
        "#{request.protocol}#{request.host}/__asset_trip__/stylesheets/" + file
      end
    end

    def _unbundled_javascript_urls(source)
      asset = AssetTrip.config.assets_hash[_source_with_extension(source, ".js")]

      asset.files.map do |file|
        "#{request.protocol}#{request.host}/__asset_trip__/javascripts/" + file
      end
    end

    def _manifest_url(source, extension)
      url = AssetTrip.manifest.path_for(_source_with_extension(source, extension))
      if request.ssl?
        url.gsub!(/#{extension}$/, ".ssl#{extension}")
      else
        url
      end
    end

    def _source_with_extension(source, extension)
      File.basename(source.to_s, extension) + extension
    end

  end
end