module AssetCrate
  module Config
    class File
      attr_reader :crates

      def initialize(&block)
        instance_eval(&block)
      end

    private

      def js_crate(name, &block)
        @crates ||= []
        @crates << Crate.new(name, &block)
      end

    end
  end
end