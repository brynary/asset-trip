module BlobBundler
  class Blob
    extend Memoizable

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

    def contents
      @blob_config.paths.map do |path|
        File.read(path)
      end.join
    end
    memoize :contents

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