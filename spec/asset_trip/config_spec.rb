require "spec_helper"

describe AssetTrip::Config do
  # TODO: it would be great to avoid needing this for these specs
  before(:all) do
    reset_filesystem!
    @old_pwd = Dir.pwd
    Dir.chdir(fixture_app)
  end

  after(:all) do
    Dir.chdir(@old_pwd)
  end

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
      js_load_path << "foo"
    end

    config.js_load_path.should == AssetTrip::LoadPath.new([
      Pathname.new("app/javascripts"),
      Pathname.new("foo")
    ])
  end

  it "supports adding to the CSS load paths" do
    config = AssetTrip::Config.new do
      css_load_path << "foo"
    end

    config.css_load_path.should == AssetTrip::LoadPath.new([
      Pathname.new("app/stylesheets"),
      Pathname.new("foo")
    ])
  end
end