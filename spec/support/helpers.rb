module BlobBundler
  module Spec
    module Helpers

      def install_js_crates(crate_source)
        FileUtils.mkdir_p(fixture_app)
        File.open(fixture_app("blob_bundles.rb"), 'w') do |f|
          f.puts crate_source
        end
      end

      def write_javascript(name, contents)
        File.open(app_javascript(name), "w") do |f|
          f.puts contents
        end
      end

      def package!
        Dir.chdir(fixture_app) do
          BlobBundler.package!
        end
      end

    end
  end
end