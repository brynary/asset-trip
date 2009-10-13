module AssetCrate
  module Config
    class ConfigFile
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

    end
  end
end