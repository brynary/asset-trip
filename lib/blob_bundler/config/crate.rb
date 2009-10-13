module BlobBundler
  module Config
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