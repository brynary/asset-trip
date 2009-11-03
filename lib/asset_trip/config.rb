module AssetTrip
  class Config

    def self.from_file(dir)
      paths = Dir[dir.join("*.rb")]
      paths.reject! { |path| File.basename(path) == "manifest.rb" }
      source = paths.map { |path| File.read(path) }.join("\n\n")
      eval "self.new {( " + source + "\n )}"
    end

    attr_reader :assets
    attr_reader :assets_hash
    attr_reader :js_load_path
    attr_reader :css_load_path

    def initialize(&block)
      @js_load_path  = LoadPath.new([Pathname.new("app/javascripts")])
      @css_load_path = LoadPath.new([Pathname.new("app/stylesheets")])

      @assets = []
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

  private

    def js_asset(name, &block)
      asset = Javascript.new(self, name, &block)
      @assets << asset
      @assets_hash[asset.name] = asset
    end

    def css_asset(name, &block)
      asset = Stylesheet.new(self, name, &block)
      @assets << asset
      @assets_hash[asset.name] = asset
    end

  end
end
