require "spec_helper"

describe BlobBundler::Config do
  it "supports setting the blob path" do
    install_js_config <<-CONFIG
      blob_path File.join(".", "custom_blobs_path")

      js_blob "signup" do
      end
    CONFIG

    bundle!
    fixture_app.should have_directory("custom_blobs_path")
  end

  it "supports adding load paths"
end