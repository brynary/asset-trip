require "spec_helper"

describe AssetTrip::Config do
  it "can bundle files included with the file extension" do
    install_js_config <<-CONFIG
      js_blob "signup" do
        include "main.js"
      end
    CONFIG
    bundle!
    blob("signup.js").should have_contents('alert("main")')
  end

  it "can bundle files in subdirectories of the load path"

  it "supports setting the blob path" do
    install_js_config <<-CONFIG
      blob_path File.join(".", "custom_blobs_path")

      js_blob "signup" do
      end
    CONFIG

    bundle!
    fixture_app.should have_directory("custom_blobs_path")
  end

  it "supports adding to the load paths"

  it "supports writing a blob to a subdirectory"
end