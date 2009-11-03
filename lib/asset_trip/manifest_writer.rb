module AssetTrip
  class ManifestWriter

    def initialize(assets)
      @assets = assets
    end

    def write!
      FileWriter.new(path).write!(contents)
    end

  private

    def contents
      source = StringIO.new

      source.puts "module AssetTrip"
      source.puts "  @manifest = Manifest.new"

      @assets.each do |asset|
        source.puts "  @manifest[#{asset.name.inspect}] = #{asset.md5sum.inspect}"
      end

      source.puts "end"

      return source.string
    end

    def path
      AssetTrip.app_root.join("config", "asset_trip", "manifest.rb")
    end

  end
end

