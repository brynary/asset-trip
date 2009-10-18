require "spec_helper"

describe AssetTrip::Config do
  it "can bundle files included with the file extension" do
    config = AssetTrip::Config.new do
      js_asset "signup" do
        include "main.js"
      end
    end

    asset_config = config.asset_configs.first
    asset_config.paths.should == [app_javascript("main.js")]
  end

  it "can bundle files in subdirectories of the load path" do
    config = AssetTrip::Config.new do
      js_asset "signup" do
        include "main/new"
      end
    end

    asset_config = config.asset_configs.first
    asset_config.paths.should == [app_javascript("main", "new.js")]
  end

  it "supports setting the assets path" do
    config = AssetTrip::Config.new do
      assets_path File.join(".", "my_assets")
    end
    config.assets_path.should == Pathname.new("./my_assets")
  end

  it "supports writing an asset to a subdirectory" do
    config = AssetTrip::Config.new do
      js_asset "signup/foo" do
        include "main.js"
      end
    end

    asset_config = config.asset_configs.first
    asset_config.name.should == "signup/foo.js"
  end

  it "supports adding to the load paths"
  it "supports setting command line flags for YUI compressor"
  it "supports disabling YUI compressor globally"
  it "supports disabling YUI compressor for an asset"
end