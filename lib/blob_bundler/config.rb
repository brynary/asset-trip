module BlobBundler
  class Config

    def self.from_file(path)
      source = File.read(path)
      eval "self.new {( " + source + "\n )}"
    end

    def initialize(&block)
      @blobs = []
      @blob_path = BlobBundler.app_root.join("public", "blobs")
      instance_eval(&block)
    end

    def bundle!
      @blobs.each do |blob_config|
        Blob.new(blob_config).bundle!
      end
    end

    def blob_path(*args)
      if args.size == 0
        return @blob_path
      else
        @blob_path = Pathname.new(args.first)
      end
    end

  private

    def js_blob(name, &block)
      @blobs << BlobConfig.new(self, name, &block)
    end

    class BlobConfig

      def initialize(config, name, &block)
        @config = config
        @name = name
        instance_eval(&block)
      end

      def blob_path
        @config.blob_path
      end

      def paths
        files.map do |f|
          load_path.join(File.basename(f, ".js") + ".js")
        end
      end

      def name
        "#{@name}.js"
      end

    private

      def include(name)
        files << name
      end

      def files
        @files ||= []
      end

      def load_path
        BlobBundler.app_root.join("app", "javascripts")
      end

    end

  end
end