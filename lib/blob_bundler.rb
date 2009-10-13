module BlobBundler
  autoload :Bundler, "blob_bundler/bundler"
  autoload :Blob, "blob_bundler/blob"
  autoload :Config, "blob_bundler/config"

  def self.bundle!
    Bundler.new.bundle!
  end
end