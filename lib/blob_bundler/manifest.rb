module BlobBundler
  class Manifest

    def initialize(blobs)
      @blobs = blobs
    end

    def write!
      File.open(path, "w") do |file|
        file.puts "module BlobBundler"
        file.puts "  @manifest = {}"

        @blobs.each do |blob|
          file.puts "  @manifest[#{blob.name.inspect}] = #{blob.md5sum.inspect}"
        end

        file.puts "end"
      end
    end

  private

    def path
      BlobBundler.app_root.join("config", "blob_manifest.rb")
    end

  end
end