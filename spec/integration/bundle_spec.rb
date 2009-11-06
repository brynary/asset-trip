require "spec_helper"
require "action_controller"

describe "rake asset_trip:bundle" do
  setup_sandbox_app!(:each)

  context "(disabling the YUI Compressor for speed)" do
    before do
      AssetTrip::Compressor.stub!(:new => DummyCompressor.new)
    end

    it "stores each Asset into the public directory" do
      install_config <<-CONFIG
        js_asset "signup" do
        end
      CONFIG
      AssetTrip.bundle!
      fixture_app.should have_asset("signup.js")
    end

    it "supports loading additional config files" do
      install_config(<<-CONFIG, "assets.rb")
        load "config/asset_trip/more_assets"
      CONFIG
      install_config(<<-CONFIG, "more_assets.rb")
        js_asset "signup" do
        end
      CONFIG
      AssetTrip.bundle!
      fixture_app.should have_asset("signup.js")
    end

    it "concatenates the files into an Asset" do
      install_config <<-CONFIG
        js_asset "signup" do
          include "main"
          include "signup"
        end
      CONFIG
      AssetTrip.bundle!
      asset("signup.js").should have_contents('alert("main")')
      asset("signup.js").should have_contents('alert("signup")')
    end

    it "uses the same path if the Asset content is the same" do
      install_config <<-CONFIG
        js_asset "signup" do
          include "main.js"
        end
      CONFIG
      AssetTrip.bundle!
      AssetTrip.bundle!
      assets("signup.js").should have(1).item
    end

    it "uses a different path if the Asset content is different" do
      install_config <<-CONFIG
        js_asset "signup" do
          include "main.js"
        end
      CONFIG
      AssetTrip.bundle!
      AssetTrip.instance_variable_set(:@config, nil)
      write_javascript("main.js", 'alert("new.main");')
      AssetTrip.bundle!
      assets("signup.js").should have(2).items
    end

    it "generates paths in the form of assets/XX/YYYYYYYY/filename.js" do
      install_config <<-CONFIG
        js_asset "signup" do
          include "main.js"
        end
      CONFIG
      AssetTrip.bundle!

      directory = assets_path.glob("*").map { |f| File.basename(f) }.first
      directory.size.should == 2
    end

    it "generates a manifest for use at runtime" do
      install_config <<-CONFIG
        js_asset "signup" do
          include "main.js"
        end
      CONFIG
      AssetTrip.bundle!

      File.read(fixture_app.join("config", "asset_trip", "manifest.rb")).should be_like(<<-RUBY)
        module AssetTrip
          @manifest = Manifest.new
          @manifest["signup.js"] = "7d6db1efb9e"
        end
      RUBY
    end

    it "rewrites URLs in CSS files to include the asset host" do
      ActionController::Base.stub!(:asset_host => "http://cdn%d.example.com")

      install_config <<-CONFIG
        css_asset "signup" do
          include "new"
        end
      CONFIG

      write_stylesheet("new.css", <<-STYLESHEET)
        .foo { background: url(/foo.jpg) }
      STYLESHEET
      AssetTrip.bundle!

      asset("signup.css").should have_contents('url(http://cdn1.example.com/foo.jpg)')
    end

    it "rewrites URLs in CSS files to include HTTPs asset hosts" do
      ActionController::Base.stub!(:asset_host => "http://cdn%d.example.com")

      install_config <<-CONFIG
        css_asset "signup" do
          include "new"
        end
      CONFIG

      write_stylesheet("new.css", <<-STYLESHEET)
        .foo { background: url(/foo.jpg) }
      STYLESHEET
      AssetTrip.bundle!

      asset("signup.ssl.css").should have_contents('url(https://cdn1.example.com/foo.jpg)')
    end

    it "respects ssl? method of request in asset proc" do
      asset_proc = Proc.new { |source, request|
        if request.ssl?
          "https://assets.example.com"
        else
          "https://cdn.example.com"
        end
      }
      ActionController::Base.stub!(:asset_host => asset_proc)
      install_config <<-CONFIG
        css_asset "signup" do
          include "new"
        end
      CONFIG

      write_stylesheet("new.css", <<-STYLESHEET)
        .foo { background: url(/foo.jpg) }
      STYLESHEET
      AssetTrip.bundle!

      asset("signup.ssl.css").should have_contents('url(https://assets.example.com/foo.jpg)')
    end

    it "does not write a new bundle if the package has not expired" do
      Time.freeze do
        install_config <<-CONFIG
          js_asset "signup" do
            include "main.js"
          end
        CONFIG
        AssetTrip.bundle!

        asset("signup.js").utime(5.minutes.ago, 5.minutes.ago)
        app_javascript("main.js").utime(10.minutes.ago, 10.minutes.ago)

        AssetTrip.bundle!
        asset("signup.js").mtime.to_i.should == 5.minutes.ago.to_i
      end
    end

    it "writes a new bundle when forced even when the package is not expired" do
      Time.freeze do
        install_config <<-CONFIG
          js_asset "signup" do
            include "main.js"
          end
        CONFIG
        AssetTrip.bundle!

        asset("signup.js").utime(5.minutes.ago, 5.minutes.ago)
        app_javascript("main.js").utime(10.minutes.ago, 10.minutes.ago)

        with_env("FORCE", "1") do
          AssetTrip.bundle!
        end
        asset("signup.js").mtime.to_i.should > 5.minutes.ago.to_i
      end
    end

    it "should use the most recent package to detect mtimes for expiry" do
      Time.freeze do
        install_config <<-CONFIG
          js_asset "signup" do
            include "main.js"
          end
        CONFIG
        AssetTrip.bundle!

        asset("signup.js").utime(5.minutes.ago, 5.minutes.ago)
        app_javascript("main.js").utime(10.minutes.ago, 10.minutes.ago)
        create_asset("46/123431bdc/signup.js", :mtime => 15.minutes.ago)

        AssetTrip.bundle!
        assets("signup.js").map { |asset|
          asset.mtime.to_i
        }.sort.should == [15.minutes.ago.to_i, 5.minutes.ago.to_i]
      end
    end
  end

  it "minifies JavaScript using the YUI Compressor" do
    install_config <<-CONFIG
      js_asset "signup" do
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
    AssetTrip.bundle!

    asset("signup.js").should_not have_contents('Comment')
    asset("signup.js").should have_contents('return a+1')
  end

  it "minifies CSS using the YUI Compressor" do
    install_config <<-CONFIG
      css_asset "signup" do
        include "new"
      end
    CONFIG

    write_stylesheet("new.css", <<-STYLESHEET)
      /* Comment */
      .foo {
        font-weight: bold;
      }
    STYLESHEET
    AssetTrip.bundle!

    asset("signup.css").should_not have_contents('Comment')
    asset("signup.css").should have_contents('.foo{font-weight:bold;}')
  end

  it "raises a CompressorError if compression fails" do
    install_config <<-CONFIG
      js_asset "signup" do
        include "main"
      end
    CONFIG
    write_javascript("main.js", "!@$%&*")

    lambda {
      AssetTrip.bundle!
    }.should raise_error(AssetTrip::CompressorError)
  end
end
