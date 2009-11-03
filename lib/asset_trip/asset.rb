require "digest"

module AssetTrip
  class Asset
    extend Memoizable

    attr_reader :files

    def initialize(config, name, files = [], &block)
      @config = config
      @name = name
      @files = files

      instance_eval(&block) if block_given?
    end

    def paths
      files.map do |file|
        @config.resolve_file(asset_type, file)
      end
    end

    def bundle!
      FileUtils.mkdir_p(File.dirname(path))

      File.open(path, "w") do |file|
        file << contents
      end
    end

    def md5sum
      @md5sum ||= Digest::MD5.hexdigest(contents)
    end

  private

    def include(name)
      name += extension unless name.ends_with?(extension)
      files << name
    end

    def contents
      joined_contents
    end
    memoize :contents

    def joined_contents
      paths.map do |path|
        File.read(path)
      end.join("\n\n")
    end

    def path
      dir.join(name)
    end

    def dir
      part1 = md5sum[0..1]
      part2 = md5sum[2..10]
      @config.assets_path.join(part1, part2)
    end

  end
end
