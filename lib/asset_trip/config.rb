module AssetTrip
  class Config

    def self.from_file(dir)
      paths = Dir[dir.join("*.rb")]
      paths.reject! { |path| File.basename(path) == "manifest.rb" }
      source = paths.map { |path| File.read(path) }.join("\n\n")
      eval "self.new {( " + source + "\n )}"
    end

    attr_reader :assets_hash
    attr_reader :load_paths

    def initialize(&block)
      @load_paths = Hash.new { LoadPath.new }
      @load_paths[:javascripts] = LoadPath.new([Pathname.new("app/javascripts")])
      @load_paths[:stylesheets] = LoadPath.new([Pathname.new("app/stylesheets")])

      @assets_hash = {}
      instance_eval(&block)
    end

    def bundle!
      assets.each do |asset|
        asset.bundle!
      end

      ManifestWriter.new(assets).write!
    end

    def assets_path
      AssetTrip.app_root.join("public", "assets")
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
