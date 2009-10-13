require "spec_helper"

describe BlobBundler, "#bundle!" do
  it "stores each Blob into the public directory" do
    install_js_config <<-CONFIG
      js_blob "signup" do
      end
    CONFIG
    bundle!
    fixture_app.should have_blob("signup.js")
  end

  it "concatenates the files into a Blob" do
    install_js_config <<-CONFIG
      js_blob "signup" do
        include "main"
        include "signup"
      end
    CONFIG
    bundle!
    blob("signup.js").should have_contents('alert("main")')
    blob("signup.js").should have_contents('alert("signup")')
  end

  it "uses the same path if the Blob content is the same" do
    install_js_config <<-CONFIG
      js_blob "signup" do
        include "main.js"
      end
    CONFIG
    bundle!
    bundle!
    blobs("signup.js").should have(1).item
  end

  it "uses a different path if the Blob content is different" do
    install_js_config <<-CONFIG
      js_blob "signup" do
        include "main.js"
      end
    CONFIG
    bundle!
    write_javascript("main.js", 'alert("new.main");')
    bundle!
    blobs("signup.js").should have(2).items
  end

  it "generates paths in the form of blobs/XX/YYYYYYYY/filename.js" do
    install_js_config <<-CONFIG
      js_blob "signup" do
        include "main.js"
      end
    CONFIG
    bundle!

    directory = blobs_path.glob("*").map { |f| File.basename(f) }.first
    directory.size.should == 2
  end

  it "generates a manifest for use at runtime" do
    install_js_config <<-CONFIG
      js_blob "signup" do
        include "main.js"
      end
    CONFIG
    bundle!

    File.read(fixture_app.join("config", "blob_manifest.rb")).should be_like(<<-RUBY)
      module BlobBundler
        @manifest = {}
        @manifest["signup.js"] = "7d6db1efb9e6b58620939540ae067c7b"
      end
    RUBY
  end
end