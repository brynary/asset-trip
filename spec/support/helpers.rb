module AssetCrate
  module Spec
    module Helpers

      def install_js_crates(crate_source)
        FileUtils.mkdir_p(fixture_app)
        File.open(fixture_app("asset_crates.rb"), 'w') do |f|
          f.puts crate_source
        end
      end

    end
  end
end