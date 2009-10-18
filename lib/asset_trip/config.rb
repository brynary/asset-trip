module AssetTrip
  class Config

    def self.from_file(dir)
      paths = Dir[dir.join("*.rb")]
      paths.reject! { |path| File.basename(path) == "manifest.rb" }
      source = paths.map { |path| File.read(path) }.join("\n\n")
      eval "self.new {( " + source + "\n )}"
    end

    attr_reader :asset_configs
    attr_reader :js_load_path
    attr_reader :css_load_path

    def initialize(&block)
      @js_load_path = LoadPath.new
      @js_load_path << "app/javascripts"

      @css_load_path = LoadPath.new
      @css_load_path << "app/stylesheets"

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

    def assets_path(*args)
      if args.size == 0
        return @assets_path
      else
        @assets_path = Pathname.new(args.first)
      end
    end

  private

    def assets
      @asset_configs.map do |asset_config|
        Asset.new(asset_config)
      end
    end

    def js_asset(name, &block)
      @asset_configs << AssetConfig.new(self, name, "js", &block)
    end

    def css_asset(name, &block)
      @asset_configs << AssetConfig.new(self, name, "css", &block)
    end

    class AssetConfig

      def initialize(config, name, type, &block)
        @config = config
        @name = name
        @type = type
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

      def name
        "#{@name}.#{@type}"
      end

    private

      def extension
        ".#{@type}"
      end

      def include(name)
        files << name
      end

      def files
        @files ||= []
      end

      def load_path
        if @type == "js"
          @config.js_load_path
        else
          @config.css_load_path
        end
      end

    end

  end
end