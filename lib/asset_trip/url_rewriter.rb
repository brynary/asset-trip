require "ostruct"
require "uri"

module AssetTrip
  class UrlRewriter
    include ActionView::Helpers::AssetTagHelper

    def initialize
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

      path_uri = URI.parse(path)
      return path if path_uri.absolute? || File.extname(path_uri.path) == '.htc'

      host = compute_asset_host(path)
      host_uri = URI.parse(host.to_s)

      if !host.blank? && host_uri.relative?
        # host_uri.scheme = "http"
        host = "http://#{host}"
      end

      host.to_s + path
      # host_uri.to_s + path
    end

    def strip_quotes!(path)
      path.gsub!(/^\s*['"]*/, "")
      path.gsub!(/['"]*\s*$/, "")
    end

  end
end