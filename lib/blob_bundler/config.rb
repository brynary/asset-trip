module BlobBundler
  class Config

    def self.from_file(path)
      source = File.read(path)
      eval "self.new {( " + source + "\n )}"
    end

    attr_reader :crates

    def initialize(&block)
      @crate_path = nil
      instance_eval(&block)
    end

    def crate_path(*args)
      if args.size == 0
        return @crate_path
      else
        @crate_path = Pathname.new(args.first)
      end
    end

  private

    def js_crate(name, &block)
      @crates ||= []
      @crates << Crate.new(name, &block)
    end

    class Crate

      def initialize(name, &block)
        @name = name
        instance_eval(&block)
      end

      def paths
        files.map do |f|
          File.basename(f, ".js") + ".js"
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

    end

  end
end