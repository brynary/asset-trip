require "spec_helper"

describe AssetTrip::Config do
  it "can bundle files included with the file extension" do
    config = AssetTrip::Config.new do
      js_blob "signup" do
        include "main.js"
      end
    end

    blob_config = config.blob_configs.first
    blob_config.paths.should == [app_javascript("main.js")]
  end

  it "can bundle files in subdirectories of the load path" do
    config = AssetTrip::Config.new do
      js_blob "signup" do
        include "main/new"
      end
    end

    blob_config = config.blob_configs.first
    blob_config.paths.should == [app_javascript("main", "new.js")]
  end

  it "supports setting the blob path" do
    config = AssetTrip::Config.new do
      blob_path File.join(".", "custom_blobs_path")
    end
    config.blob_path.should == Pathname.new("./custom_blobs_path")
  end

  it "supports writing a blob to a subdirectory" do
    config = AssetTrip::Config.new do
      js_blob "signup/foo" do
        include "main.js"
      end
    end

    blob_config = config.blob_configs.first
    blob_config.name.should == "signup/foo.js"
  end

  it "supports adding to the load paths"
end