require "spec_helper"

describe BlobBundler::Config do
  it "supports setting the crate path" do
    install_js_crates <<-CRATE
      crate_path File.join(".", "custom_crates_path")

      js_crate "signup" do
      end
    CRATE

    package!
    fixture_app.should have_directory("custom_crates_path")
  end

  it "supports adding load paths"
end