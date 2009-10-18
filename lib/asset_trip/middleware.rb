# This is based on Rack::Static and Rack::File
module AssetTrip
  class Middleware
    URL_PREFIX = "/__asset_trip__"

    def initialize(app)
      @root = File.join(Dir.pwd, "app", "javascripts")
      @app = app
    end

    def call(env)
      dup._call(env)
    end

    def _call(env)
      @path_info = Rack::Utils.unescape(env["PATH_INFO"])

      if @path_info.index(URL_PREFIX) == 0
        return forbidden if @path_info.include?("..")
        @path = File.join(@root, @path_info[URL_PREFIX.size..-1])

        if File.file?(@path) && File.readable?(@path)
          serving
        else
          not_found
        end
      else
        @app.call(env)
      end
    end

    def serving
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

    def each
      File.open(@path, "rb") do |file|
        while part = file.read(8192)
          yield part
        end
      end
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