module AssetTrip
  class Manifest

    def initialize(assets)
      @assets = assets
    end

    def write!
      File.open(path, "w") do |file|
        file.puts "module AssetTrip"
        file.puts "  @manifest = {}"

        @assets.each do |asset|
          file.puts "  @manifest[#{asset.name.inspect}] = #{asset.md5sum.inspect}"
        end

        file.puts "end"
      end
    end

  private

    def path
      AssetTrip.app_root.join("config", "asset_trip", "manifest.rb")
    end

  end
end