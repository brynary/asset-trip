module BlobBundler
  class Blob

    def initialize(blob_config)
      @blob_config = blob_config
    end

    def bundle!
      FileUtils.mkdir_p(@blob_config.blob_path)

      File.open(path, "w") do |file|
        file << contents
      end
    end

  private

    def load_path
      BlobBundler.app_root.join("app", "javascripts")
    end

    def contents
      @contents ||= begin
        buffer = ""
        @blob_config.paths.each do |path|
          buffer << File.read(load_path.join(path))
        end
        buffer
      end
    end

    def path
      FileUtils.mkdir_p(dir)
      dir.join(@blob_config.name)
    end

    def dir
      part1 = md5sum[0..1]
      part2 = md5sum[2..10]
      @blob_config.blob_path.join(part1, part2)
    end

    def md5sum
      @md5sum ||= Digest::MD5.hexdigest(contents)
    end

  end
end