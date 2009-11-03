require "action_controller"
require "action_view"
require "ostruct"
require "uri"

module AssetTrip
  class UrlRewriter
    include ActionView::Helpers::AssetTagHelper

    def initialize(scheme = "http")
      @scheme = scheme

      # Used by Rails compute_asset_host method from ActionView::Helpers::AssetTagHelper
      @controller = OpenStruct.new(:request => ActionController::Request.new({}))
    end

    def rewrite(contents)
      contents.gsub!(/url *\(([^\)]+)\)/) do
        "url(#{add_asset_host_to_path($1)})"
      end
      contents
    end

  private

    def add_asset_host_to_path(path)
      strip_quotes!(path)

      if prepend_asset_host?(path)
        URI::Generic.build(uri_components(path)).to_s
      else
        path
      end
    end

    def uri_components(path)
      opts = { :path => path }

      if (asset_id = rails_asset_id(path)).present?
        opts[:query] = asset_id
      end

      if (host = compute_asset_host(path)).present?
        opts[:host]   = strip_scheme(host)
        opts[:scheme] = @scheme
      end

      return opts
    end

    def prepend_asset_host?(path)
      uri = URI.parse(path)

      uri.path.starts_with?('/') &&
      uri.relative? &&
      File.extname(uri.path) != '.htc'
    end

    def strip_scheme(host)
      host.gsub(/^[a-z]+:\/\//, '')
    end

    def strip_quotes!(path)
      path.gsub!(/^\s*['"]*/, "")
      path.gsub!(/['"]*\s*$/, "")
    end

  end
end
