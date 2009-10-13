require "spec_helper"

describe BlobBundler do
  it "stores each crate into the crate path" do
    install_js_crates <<-CRATE
      js_crate "signup" do
      end
    CRATE
    bundle!
    fixture_app.should have_crate("signup.js")
  end

  it "concatenates the included files" do
    install_js_crates <<-CRATE
      js_crate "signup" do
        include "main"
        include "signup"
      end
    CRATE
    bundle!
    crate("signup.js").should have_contents("main.js.contents")
    crate("signup.js").should have_contents("signup.js.contents")
  end

  it "works with the file extensions included" do
    install_js_crates <<-CRATE
      js_crate "signup" do
        include "main.js"
      end
    CRATE
    bundle!
    crate("signup.js").should have_contents("main.js.contents")
  end

  it "uses the same path if the crate content is the same" do
    install_js_crates <<-CRATE
      js_crate "signup" do
        include "main.js"
      end
    CRATE
    bundle!
    bundle!
    crates("signup.js").should have(1).item
  end

  it "uses a differ path if the crate content is different" do
    install_js_crates <<-CRATE
      js_crate "signup" do
        include "main.js"
      end
    CRATE
    bundle!
    write_javascript("main.js", "new.main.js.contents")
    bundle!
    crates("signup.js").should have(2).items
  end

  it "never creates more than 256 directories in the crate path" do
    install_js_crates <<-CRATE
      js_crate "signup" do
        include "main.js"
      end
    CRATE

    bundle!
    directory = crates_path.glob("*").map { |f| File.basename(f) }.first
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