require "spec_helper"

describe BlobBundler do
  it "stores each blob into the blob path" do
    install_js_config <<-CONFIG
      js_blob "signup" do
      end
    CONFIG
    bundle!
    fixture_app.should have_blob("signup.js")
  end

  it "concatenates the included files" do
    install_js_config <<-CONFIG
      js_blob "signup" do
        include "main"
        include "signup"
      end
    CONFIG
    bundle!
    blob("signup.js").should have_contents("main.js.contents")
    blob("signup.js").should have_contents("signup.js.contents")
  end

  it "works with the file extensions included" do
    install_js_config <<-CONFIG
      js_blob "signup" do
        include "main.js"
      end
    CONFIG
    bundle!
    blob("signup.js").should have_contents("main.js.contents")
  end

  it "uses the same path if the blob content is the same" do
    install_js_config <<-CONFIG
      js_blob "signup" do
        include "main.js"
      end
    CONFIG
    bundle!
    bundle!
    blobs("signup.js").should have(1).item
  end

  it "uses a differ path if the blob content is different" do
    install_js_config <<-CONFIG
      js_blob "signup" do
        include "main.js"
      end
    CONFIG
    bundle!
    write_javascript("main.js", "new.main.js.contents")
    bundle!
    blobs("signup.js").should have(2).items
  end

  it "never creates more than 256 directories in the blobs path" do
    install_js_config <<-CONFIG
      js_blob "signup" do
        include "main.js"
      end
    CONFIG

    bundle!
    directory = blobs_path.glob("*").map { |f| File.basename(f) }.first
    directory.size.should == 2
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