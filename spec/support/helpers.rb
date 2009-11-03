module AssetTrip
  module Spec
    module Helpers

      def install_js_config(config_source, filename = "assets.rb")
        FileUtils.mkdir_p(fixture_app)
        File.open(fixture_app("config", "asset_trip", filename), 'w') do |f|
          f.puts config_source
        end
      end

      def write_javascript(name, contents)
        File.open(app_javascript(name), "w") do |f|
          f.puts contents
        end
      end

      def write_stylesheet(name, contents)
        File.open(app_stylesheet(name), "w") do |f|
          f.puts contents
        end
      end

    end
  end
end
