require 'popen4'

module AssetTrip
  class Compressor

    def initialize(type)
      @type = type
    end

    def compress(contents)
      out = nil
      err = nil

      status = POpen4.popen4(command) do |stdout, stderr, stdin, pid|
        stdin.puts contents
        stdin.close
        out = stdout.read.strip
        err = stderr.read.strip
      end

      raise CompressorError.new(err) unless status.success?
      return out
    end

  private

    def command
      "java -jar #{jar_path} --type #{@type}"
    end

    def jar_path
      AssetTrip.root.join("vendor", "yuicompressor-2.4.2.jar")
    end

  end
end