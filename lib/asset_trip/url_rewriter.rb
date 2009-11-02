require "ostruct"

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
      return path if path.include?('.htc')
      strip_quotes!(path)
      return path if path.starts_with?("http")

      host = compute_asset_host(path)

      if !host.blank? && host !~ %r{^[-a-z]+://}
        host = "http://#{host}"
      end

      host.to_s + path
    end

    def strip_quotes!(path)
      path.gsub!(/^\s*['"]*/, "")
      path.gsub!(/['"]*\s*$/, "")
    end

  end
end