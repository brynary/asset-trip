module AssetTrip
  class Config

    def self.from_file(dir)
      paths = Dir[dir.join("*.rb")]
      paths.reject! { |path| File.basename(path) == "manifest.rb" }
      source = paths.map { |path| File.read(path) }.join("\n\n")
      eval "self.new {( " + source + "\n )}"
    end

    attr_reader :assets_path
    attr_reader :asset_configs

    attr_reader :js_load_path
    attr_reader :css_load_path

    def initialize(&block)
      @js_load_path = LoadPath.new([Pathname.new("app/javascripts")])
      @css_load_path = LoadPath.new([Pathname.new("app/stylesheets")])

      @asset_configs = []
      @assets_path = AssetTrip.app_root.join("public", "assets")

      instance_eval(&block)
    end

    def bundle!
      assets.each do |asset|
        asset.bundle!
      end

      Manifest.new(assets).write!
    end

  private

    def assets
      @asset_configs.map(&:asset)
    end

    def js_asset(name, &block)
      @asset_configs << JavascriptConfig.new(self, name, &block)
    end

    def css_asset(name, &block)
      @asset_configs << StylesheetConfig.new(self, name, &block)
    end

    class AssetConfig

      def initialize(config, name, &block)
        @config = config
        @name = name
        instance_eval(&block)
      end

      def assets_path
        @config.assets_path
      end

      def paths
        files.map do |f|
          f += extension unless f.ends_with?(extension)
          load_path.resolve(f)
        end
      end

    private

      def include(name)
        files << name
      end

      def files
        @files ||= []
      end

    end

    class JavascriptConfig < AssetConfig

      def asset
        Javascript.new(self)
      end

      def name
        "#{@name}.js"
      end

    private

      def load_path
        @config.js_load_path
      end

      def extension
        ".js"
      end

    end

    class StylesheetConfig < AssetConfig

      def asset
        Stylesheet.new(self)
      end

      def name
        "#{@name}.css"
      end

    private

      def load_path
        @config.css_load_path
      end

      def extension
        ".css"
      end

    end


  end
end