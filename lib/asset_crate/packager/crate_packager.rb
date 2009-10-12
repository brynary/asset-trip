require "digest"

module AssetCrate
  class Packager
    class CratePackager
      attr_reader :crate, :crate_path, :load_path

      def initialize(load_path, crate_path, crate)
        @crate_path = crate_path
        @crate = crate
        @load_path = load_path
      end

      def package!
        File.open(path, "w") do |file|
          file << contents
        end
      end

    private

      def contents
        @contents ||= begin
          buffer = ""
          crate.paths.each do |path|
            buffer << File.read(load_path.join(path))
          end
          buffer
        end
      end

      def path
        FileUtils.mkdir_p(dir)
        dir.join(crate.name)
      end

      def dir
        # part1 = md5sum[0..1]
        # part2 = md5sum[2..10]
        crate_path.join(md5sum)
      end

      def md5sum
        @md5sum ||= Digest::MD5.hexdigest(contents)
      end

    end
  end
end