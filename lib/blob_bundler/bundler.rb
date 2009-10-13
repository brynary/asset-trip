module BlobBundler
  class Bundler

    def bundle!
      FileUtils.mkdir_p(crate_path)

      config.crates.each do |crate|
        packager = Blob.new(load_path, crate_path, crate)
        packager.bundle!
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
      app_path.join("blob_bundles.rb")
    end

    def crate_path
      config.crate_path || app_path.join("public", "crates")
    end

    def app_path
      Pathname.new(".").expand_path
    end

  end
end