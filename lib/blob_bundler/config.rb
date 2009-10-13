module BlobBundler
  class Config

    def self.from_file(path)
      source = File.read(path)
      eval "self.new {( " + source + "\n )}"
    end

    def initialize(&block)
      @blob_configs = []
      @blob_path = BlobBundler.app_root.join("public", "blobs")
      instance_eval(&block)
    end

    def bundle!
      blobs.each do |blob|
        blob.bundle!
      end

      Manifest.new(blobs).write!
    end

    def blob_path(*args)
      if args.size == 0
        return @blob_path
      else
        @blob_path = Pathname.new(args.first)
      end
    end

  private

    def blobs
      @blob_configs.map do |blob_config|
        Blob.new(blob_config)
      end
    end

    def js_blob(name, &block)
      @blob_configs << BlobConfig.new(self, name, "js", &block)
    end

    def css_blob(name, &block)
      @blob_configs << BlobConfig.new(self, name, "css", &block)
    end

    class BlobConfig

      def initialize(config, name, type, &block)
        @config = config
        @name = name
        @type = type
        instance_eval(&block)
      end

      def blob_path
        @config.blob_path
      end

      def paths
        files.map do |f|
          load_path.join(File.basename(f, extension) + extension)
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
          BlobBundler.app_root.join("app", "javascripts")
        else
          BlobBundler.app_root.join("app", "stylesheets")
        end
      end

    end

  end
end