module AssetCrate
  module Spec
    module PathUtils

      def root
        Pathname.new(__FILE__).dirname.join('..', '..').expand_path
      end

      def tmp_path
        root.join("tmp")
      end

      def fixture_app(*args)
        tmp_path.join("fixture_app", *args)
      end

      def reset_filesystem!
        tmp_path.rmtree if tmp_path.exist?
        tmp_path.mkdir
      end

    end
  end
end