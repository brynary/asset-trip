require "spec_helper"

describe AssetTrip::Config do
  # TODO: it would be great to avoid needing this for these specs
  setup_sandbox_app!

  it "can bundle files included with the file extension" do
    config = AssetTrip::Config.new do
      js_asset "signup" do
        include "main.js"
      end
    end

    asset_config = config.assets.first
    asset_config.paths.should == [app_javascript("main.js")]
  end

  it "can bundle files in subdirectories of the load path" do
    config = AssetTrip::Config.new do
      js_asset "signup" do
        include "main/new"
      end
    end

    asset_config = config.assets.first
    asset_config.paths.should == [app_javascript("main", "new.js")]
  end

  it "should not allow empty asset trip configurations" do
    lambda { AssetTrip::Config.new do
      js_asset "signup" do
      end
    end }.should raise_error(AssetTrip::InvalidAssetError, "javascript asset 'signup' does not contain any files")
  end

  it "supports writing an asset to a subdirectory" do
    config = AssetTrip::Config.new do
      js_asset "signup/foo" do
        include "main.js"
      end
    end

    asset_config = config.assets.first
    asset_config.name.should == "signup/foo.js"
  end

  it "supports adding to the JS load paths" do
    config = AssetTrip::Config.new do
      load_paths[:javascripts] << "foo"
    end

    config.load_paths[:javascripts].should == AssetTrip::LoadPath.new([
      Pathname.new("app/javascripts"),
      Pathname.new("foo")
    ])
  end

  it "supports adding to the CSS load paths" do
    config = AssetTrip::Config.new do
      load_paths[:stylesheets] << "foo"
    end

    config.load_paths[:stylesheets].should == AssetTrip::LoadPath.new([
      Pathname.new("app/stylesheets"),
      Pathname.new("foo")
    ])
  end
end
