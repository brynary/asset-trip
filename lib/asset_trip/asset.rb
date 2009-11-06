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

    def bundle!
      FileWriter.new(path).write!(contents) if expired?
    end

    def contents
      compressor.compress(joined_contents)
    end
    memoize :contents

    def paths
      files.map do |file|
        @config.resolve_file(asset_type, file)
      end
    end
    memoize :paths

    def md5sum
      if expired?
        Digest::MD5.hexdigest(contents)
      else
        last_package.dirname.to_s.last(12).gsub("/", "")
      end
    end
    memoize :md5sum

  private

    def last_package
      packaged_files.sort_by { |path| File.mtime(path) }.last
    end

    def expired?
      ENV["FORCE"] || packaged_files.empty? || generated_at <= last_change_at
    end

    def generated_at
      packaged_file_mtimes.last
    end

    def packaged_file_mtimes
      @packaged_file_mtimes ||= packaged_files.map { |path| File.mtime(path) }.sort
    end

    def packaged_files
      Dir[AssetTrip.assets_path.join("**", name)]
    end

    def last_change_at
      mtimes.last
    end

    def mtimes
      @mtimes ||= paths.map { |path| File.mtime(path) }.sort
    end

    def include(name)
      name += extension unless name.ends_with?(extension)
      files << name
    end

    def path
      dir.join(name)
    end

    def dir
      part1 = md5sum[0..1]
      part2 = md5sum[2..10]
      AssetTrip.assets_path.join(part1, part2)
    end

  end
end
