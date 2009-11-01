require "active_support"

module AssetTrip
  autoload :Asset, "asset_trip/asset"
  autoload :Compressor, "asset_trip/compressor"
  autoload :Config, "asset_trip/config"
  autoload :Helper, "asset_trip/helper"
  autoload :JavascriptProcessor, "asset_trip/javascript_processor"
  autoload :LoadPath, "asset_trip/load_path"
  autoload :Manifest, "asset_trip/manifest"
  autoload :Middleware, "asset_trip/middleware"
  autoload :Memoizable, "asset_trip/memoizable"
  autoload :StylesheetProcessor, "asset_trip/stylesheet_processor"
  autoload :UrlRewriter, "asset_trip/url_rewriter"

  class CompressorError < StandardError
  end

  def self.bundle!
    Config.from_file(config_path).bundle!
  end

  def self.manifest
    @manifest
  end

  def self.app_root
    Pathname.new(".").expand_path
  end

  def self.root
    Pathname.new(File.dirname(__FILE__)).join("..").expand_path
  end

  def self.config_path
    app_root.join("config", "asset_trip")
  end

end