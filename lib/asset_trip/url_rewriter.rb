require "ostruct"
require "uri"

module AssetTrip
  class UrlRewriter
    include ActionView::Helpers::AssetTagHelper

    def initialize
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
      return path unless prepend_asset_host?(path)

      host = compute_asset_host(path).to_s
      return path if host.blank?

      URI::Generic.build(
        :host   => strip_scheme(host),
        :scheme => "http",
        :path   => path
      ).to_s
    end

    def prepend_asset_host?(path)
      uri = URI.parse(path)
      uri.relative? && File.extname(uri.path) != '.htc'
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