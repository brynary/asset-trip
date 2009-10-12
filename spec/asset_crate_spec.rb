require "spec_helper"

describe AssetCrate do
  it "stores each crate into the crate path" do
    install_js_crates <<-CRATE
      js_crate "signup" do
      end
    CRATE
    AssetCrate.package!
    fixture_app.should have_crate("signup.js")
  end

  it "concatenates the included files" do
    install_js_crates <<-CRATE
      js_crate "signup" do
        include "main"
        include "signup"
      end
    CRATE
    AssetCrate.package!
    crate("signup.js").should have_contents("main.js.contents")
    crate("signup.js").should have_contents("signup.js.contents")
  end

  it "works with the file extensions included" do
    install_js_crates <<-CRATE
      js_crate "signup" do
        include "main.js"
      end
    CRATE
    AssetCrate.package!
    crate("signup.js").should have_contents("main.js.contents")
  end

  it "stores the crates in the crate path"
  it "finds assets in the load paths"

  it "uses the same path if the crate content is the same" do
    install_js_crates <<-CRATE
      js_crate "signup" do
        include "main.js"
      end
    CRATE
    AssetCrate.package!
    AssetCrate.package!
    crates("signup.js").should have(1).item
  end

  def write_javascript(name, contents)
    File.open(app_javascript(name), "w") do |f|
      f.puts contents
    end
  end

  it "uses a differ path if the crate content is different" do
    install_js_crates <<-CRATE
      js_crate "signup" do
        include "main.js"
      end
    CRATE
    AssetCrate.package!
    write_javascript("main.js", "")
    AssetCrate.package!
    crates("signup.js").should have(2).items
  end

  it "never creates more than 256 directories in the crate path" do
    install_js_crates <<-CRATE
      js_crate "signup" do
        include "main.js"
      end
    CRATE
    AssetCrate.package!
    write_javascript("main.js", "")
    AssetCrate.package!
    crates("signup.js").should have(2).items
  end

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