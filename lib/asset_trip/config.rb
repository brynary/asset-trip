module AssetTrip
  class Config

    def self.from_file(dir)
      source = File.read(dir.join("assets.rb"))
      eval "self.new {( " + source + "\n )}"
    end

    attr_reader :assets_hash
    attr_reader :load_paths

    def initialize(&block)
      @load_paths = Hash.new { LoadPath.new }
      @load_paths[:javascripts] = LoadPath.new(["app/javascripts"])
      @load_paths[:stylesheets] = LoadPath.new(["app/stylesheets"])

      @assets_hash = {}
      instance_eval(&block)
    end

    def bundle!
      assets.each do |asset|
        asset.bundle!
      end

      ManifestWriter.new(assets).write!
    end

    def resolve_file(asset_type, file)
      @load_paths[asset_type].resolve(file)
    end

    def assets
      @assets_hash.values
    end

  private

    def js_asset(name, &block)
      asset = Javascript.new(self, name, &block)
      @assets_hash[asset.name] = asset
    end

    def css_asset(name, &block)
      asset = Stylesheet.new(self, name, &block)
      @assets_hash[asset.name] = asset

      ssl_asset = asset.ssl_stylesheet
      @assets_hash[ssl_asset.name] = ssl_asset
    end

  end
end
