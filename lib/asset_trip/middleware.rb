# This is based on Rack::Static and Rack::File
module AssetTrip
  class Middleware
    URL_PREFIX = "/__asset_trip__"

    def initialize(app)
      @app = app
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      @env = env

      if matches_url_prefix?
        process
      else
        pass
      end
    end

    def each
      File.open(path, "rb") do |file|
        while part = file.read(8192)
          yield part
        end
      end
    end

  private

    def matches_url_prefix?
      path_info.index(URL_PREFIX) == 0
    end

    def process
      return forbidden if path_info.include?("..")

      if File.file?(path) && File.readable?(path)
        serve_file
      else
        not_found
      end
    rescue UnknownAssetError
      return not_found
    end

    def pass
      @app.call(@env)
    end

    def path
      @path ||= load_path.resolve(filename)
    end

    def filename
      @filename ||= path_info[("/#{URL_PREFIX}/#{asset_type}".size)..-1]
    end

    def path_info
      @path_info ||= Rack::Utils.unescape(@env["PATH_INFO"])
    end

    def asset_type
      path_parts[2]
    end

    def load_path
      if asset_type == "javascripts"
        AssetTrip.config.js_load_path
      elsif asset_type == "stylesheets"
        AssetTrip.config.css_load_path
      else
        AssetTrip::LoadPath.new
      end
    end

    def path_parts
      path_info.split("/")
    end

    def serve_file
      # NOTE:
      #   We check via File::size? whether this file provides size info
      #   via stat (e.g. /proc files often don't), otherwise we have to
      #   figure it out by reading the whole file into memory. And while
      #   we're at it we also use this as body then.
      if size = File.size?(@path)
        body = self
      else
        body = [File.read(@path)]
        size = Rack::Utils.bytesize(body.first)
      end

      [200, {
        "Last-Modified"  => File.mtime(@path).httpdate,
        "Content-Type"   => Rack::Mime.mime_type(File.extname(@path), 'text/plain'),
        "Content-Length" => size.to_s
      }, body]
    end

    def forbidden
      body = "Forbidden\n"
      [403, {"Content-Type" => "text/plain",
             "Content-Length" => body.size.to_s},
       [body]]
    end

    def not_found
      body = "File not found: #{@path_info}\n"
      [404, {"Content-Type" => "text/plain",
         "Content-Length" => body.size.to_s},
       [body]]
    end

  end
end