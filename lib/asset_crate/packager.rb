module AssetCrate
  class Packager
    autoload :CratePackager, "asset_crate/packager/crate_packager"

    def package!
      FileUtils.mkdir_p(crate_path)

      config.crates.each do |crate|
        packager = CratePackager.new(load_path, crate_path, crate)
        packager.package!
      end
    end

  private

    def config
      Config.from_file(config_path)
    end

    def load_path
      app_path.join("app", "javascripts")
    end

    def config_path
      app_path.join("asset_crates.rb")
    end

    def crate_path
      config.crate_path || app_path.join("public", "crates")
    end

    def app_path
      Pathname.new(".").expand_path
    end

  end
end