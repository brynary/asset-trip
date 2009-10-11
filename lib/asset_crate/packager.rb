module AssetCrate
  class Packager
    def package!
      config = Config.from_file(config_path)

      FileUtils.mkdir_p(crate_path)

      config.crates.each do |name|
        File.open(crate_path.join("#{name}.css"), "w") do |f|
          f.puts "blah"
        end
      end
    end

    def config_path
      app_path.join("asset_crates.rb")
    end

    def crate_path
      app_path.join("public", "crates")
    end

    def app_path
      Pathname.new(".").join("tmp", "fixture_app")
    end
  end
end