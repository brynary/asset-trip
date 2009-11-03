require "action_controller"
require "action_view"
require "ostruct"
require "uri"

module AssetTrip
  class UrlRewriter
    include ActionView::Helpers::AssetTagHelper

    def initialize(scheme, path = nil)
      @scheme = scheme
      @path = nil

      # Used by Rails compute_asset_host method from ActionView::Helpers::AssetTagHelper
      @controller = OpenStruct.new(:request => ActionController::Request.new({}))
    end

    def rewrite(contents)
      contents.gsub(/url *\(([^\)]+)\)/) do
        "url(#{add_asset_host_to_path($1)})"
      end
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
      opts = { :path => rewrite_relative_path(path) }

      if (asset_id = rails_asset_id(path)).present?
        opts[:query] = asset_id
      end

      if (host = compute_asset_host(path)).present?
        opts[:host]   = strip_scheme(host)
        opts[:scheme] = @scheme
      end

      return opts
    end

    def rewrite_relative_path(path)
      return path
      # return relative_url if relative_url.first == "/" || relative_url.include?("://")
      #
      # elements = File.join("/", File.dirname(source_filename)).split("/") + relative_url.split("/")
      #
      # index = 0
      #
      # while elements[index]
      #   case elements[index]
      #   when "."
      #     elements.delete_at(index)
      #   when ".."
      #     next if index == 0
      #     index -=1
      #     2.times { elements.delete_at(index) }
      #   else
      #     index +=1
      #   end
      # end
      #
      # elements.join("/")
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
