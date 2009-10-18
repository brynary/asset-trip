module AssetTrip
  class UrlRewriter

    def initialize(path)
      @path = path
    end

    def rewrite(contents)
      contents.gsub!(/url *\(([^\)]+)\)/) { "url(#{add_asset_host_to_path($1)})" }
      contents
    end

  private

    def add_asset_host_to_path(path)
      return path if path.include?('.htc')

      path.gsub!(/^\s*['"]*/, "")
      path.gsub!(/['"]*\s*$/, "")

      return path if path.starts_with?("http")

      host = compute_asset_host(path)

      if !host.blank? && host !~ %r{^[-a-z]+://}
        host = "http://#{host}"
      end

      host + path
    end

    def compute_asset_host(source)
      if host = ActionController::Base.asset_host
        # if host.is_a?(Proc)
        #   case host.arity
        #   when 2
        #     host.call(source, request)
        #   else
        #     host.call(source)
        #   end
        # else
          (host =~ /%d/) ? host % (source.hash % 4) : host
        # end
      end
    end

    def request
    end

  end
end