module AssetTrip
  class Manifest

    def initialize(blobs)
      @blobs = blobs
    end

    def write!
      File.open(path, "w") do |file|
        file.puts "module AssetTrip"
        file.puts "  @manifest = {}"

        @blobs.each do |blob|
          file.puts "  @manifest[#{blob.name.inspect}] = #{blob.md5sum.inspect}"
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