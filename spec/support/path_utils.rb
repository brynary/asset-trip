module AssetTrip
  module Spec
    module PathUtils

      def reset_filesystem!
        tmp_path.rmtree if tmp_path.exist?
        tmp_path.mkdir
        FileUtils.cp_r(root.join("spec", "fixtures"), fixture_app)
      end

      def root
        Pathname.new(__FILE__).dirname.join('..', '..').expand_path
      end

      def tmp_path
        root.join("tmp")
      end

      def fixture_app(*args)
        tmp_path.join("fixture_app", *args)
      end

      def app_javascript(*args)
        fixture_app.join("app", "javascripts", *args)
      end

      def app_stylesheet(*args)
        fixture_app.join("app", "stylesheets", *args)
      end

      def blob(name)
        blobs(name).first
      end

      def blobs(name)
        blobs_path.glob("**", name)
      end

      def blobs_path
        fixture_app.join("public", "blobs")
      end

    end
  end
end