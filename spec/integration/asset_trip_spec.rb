require "spec_helper"

describe AssetTrip do
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

    File.read(fixture_app.join("config", "asset_trip", "manifest.rb")).should be_like(<<-RUBY)
      module AssetTrip
        @manifest = {}
        @manifest["signup.js"] = "7d6db1efb9e6b58620939540ae067c7b"
      end
    RUBY
  end

  it "minifies JavaScript using the YUI Compressor" do
    install_js_config <<-CONFIG
      js_blob "signup" do
        include "main"
      end
    CONFIG

    write_javascript("main.js", <<-JAVASCRIPT)
      // Comment
      function foo() {
        var long_var_name = 1;
        return long_var_name + 1;
      }
    JAVASCRIPT
    bundle!

    blob("signup.js").should_not have_contents('Comment')
    blob("signup.js").should have_contents('return a+1')
  end

  it "minifies CSS using the YUI Compressor" do
    install_js_config <<-CONFIG
      css_blob "signup" do
        include "new"
      end
    CONFIG

    write_stylesheet("new.css", <<-STYLESHEET)
      /* Comment */
      .foo {
        font-weight: bold;
      }
    STYLESHEET
    bundle!

    blob("signup.css").should_not have_contents('Comment')
    blob("signup.css").should have_contents('.foo{font-weight:bold;}')
  end

  it "raises a CompressorError if compression fails" do
    install_js_config <<-CONFIG
      js_blob "signup" do
        include "main"
      end
    CONFIG
    write_javascript("main.js", "!@$%&*")

    lambda {
      bundle!
    }.should raise_error(AssetTrip::CompressorError)
  end


  it "rewrites URLs in CSS files to include the asset host" do
    ActionController::Base.stub!(:asset_host => "http://cdn%d.example.com")

    install_js_config <<-CONFIG
      css_blob "signup" do
        include "new"
      end
    CONFIG

    write_stylesheet("new.css", <<-STYLESHEET)
      .foo { background: url(/foo.jpg) }
    STYLESHEET
    bundle!

    blob("signup.css").should have_contents('url(http://cdn1.example.com/foo.jpg)')
  end
end
