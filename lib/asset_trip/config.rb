module AssetTrip
  class Config

    def self.from_file(path)
      source = File.read(path)
      eval "self.new {( " + source + "\n )}"
    end

    attr_reader :asset_configs

    def initialize(&block)
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
          load_path.join(f)
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
          AssetTrip.app_root.join("app", "javascripts")
        else
          AssetTrip.app_root.join("app", "stylesheets")
        end
      end

    end

  end
end