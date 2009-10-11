require "spec_helper"

describe AssetCrate do
  it "stores each create into the crate path" do
    install_css_crates <<-CRATE
      css_create "signup" do
        include "main"
      end
    CRATE

    AssetCrate.package!
    fixture_app.should have_crate("signup.css")
  end

  it "uses the same path if the create content is the same"
  it "uses a differ path if the create content is different"
  it "generates a manifest for the current version of the assets"

  describe "for javascript" do
    it "minifies the code"
  end

  describe "for stylesheets" do
    it "strips comments"
    it "collapses spaces"
    it "adds asset host subdomains to background images"
  end
end