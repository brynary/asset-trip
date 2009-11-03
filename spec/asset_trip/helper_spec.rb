require "spec_helper"
require "action_controller"
require "action_view"

describe AssetTrip::Helper do
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::AssetTagHelper
  include AssetTrip::Helper

  before do
    # Silence ruby -W warning triggered inside asset_tag_helper.rb
    @controller = nil
  end

  def request
    stub(:host => "localhost.com", :ssl? => false, :protocol => "http://")
  end

  describe "#javascript_include_asset" do
    it "generates a <script> tag based on the Manifest" do
      AssetTrip.stub!(:manifest => AssetTrip::Manifest.new("foo.js" => "884695aafa07bf0c3e1f1fe578dd10d0"))
      javascript_include_asset("foo").should be_like(<<-HTML)
        <script src="/assets/88/4695aafa0/foo.js" type="text/javascript"></script>
      HTML
    end

    it "generates multiple <script> tags" do
      AssetTrip.stub!(:manifest => AssetTrip::Manifest.new(
        "foo.js" => "884695aafa07bf0c3e1f1fe578dd10d0",
        "bar.js" => "1349f22e9bd188ef71503ba80624fc68"))
      javascript_include_asset("foo", "bar").should be_like(<<-HTML)
        <script src="/assets/88/4695aafa0/foo.js" type="text/javascript"></script>
        <script src="/assets/13/49f22e9bd/bar.js" type="text/javascript"></script>
      HTML
    end

    it "works with the file extension specified" do
      AssetTrip.stub!(:manifest => AssetTrip::Manifest.new("foo.js" => "884695aafa07bf0c3e1f1fe578dd10d0"))
      javascript_include_asset("foo.js").should be_like(<<-HTML)
        <script src="/assets/88/4695aafa0/foo.js" type="text/javascript"></script>
      HTML
    end

    it "works with symbols" do
      AssetTrip.stub!(:manifest => AssetTrip::Manifest.new("foo.js" => "884695aafa07bf0c3e1f1fe578dd10d0"))
      javascript_include_asset(:foo).should be_like(<<-HTML)
        <script src="/assets/88/4695aafa0/foo.js" type="text/javascript"></script>
      HTML
    end

    it "raises an UnknownAssetError if it's not in the manifest" do
      AssetTrip.stub!(:manifest => AssetTrip::Manifest.new)
      lambda {
        javascript_include_asset("foo")
      }.should raise_error(AssetTrip::UnknownAssetError)
    end

    it "does not add file mtimes into the query string" do
      AssetTrip.stub!(:manifest => AssetTrip::Manifest.new("foo.js" => "884695aafa07bf0c3e1f1fe578dd10d0"))
      stub!(:rails_asset_id => "rails_asset_id")
      javascript_include_asset("foo").should_not include("rails_asset_id")
    end

    it "does not prevent mtimes from being added to other JavaScripts" do
      stub!(:rails_asset_id => "rails_asset_id")
      javascript_include_tag("foo").should include("rails_asset_id")
    end
  end

  describe "#stylesheet_link_asset" do
    it "generates a <style> tag based on the manifest" do
      AssetTrip.stub!(:manifest => AssetTrip::Manifest.new("foo.css" => "884695aafa07bf0c3e1f1fe578dd10d0"))
      stylesheet_link_asset("foo").should be_like(<<-HTML)
        <link href="/assets/88/4695aafa0/foo.css" media="screen" rel="stylesheet" type="text/css" />
      HTML
    end

    it "generates multiple <style> tags" do
      AssetTrip.stub!(:manifest => AssetTrip::Manifest.new(
        "foo.css" => "884695aafa07bf0c3e1f1fe578dd10d0",
        "bar.css" => "1349f22e9bd188ef71503ba80624fc68"))
      stylesheet_link_asset("foo", "bar").should be_like(<<-HTML)
        <link href="/assets/88/4695aafa0/foo.css" media="screen" rel="stylesheet" type="text/css" />
        <link href="/assets/13/49f22e9bd/bar.css" media="screen" rel="stylesheet" type="text/css" />
      HTML
    end

    it "supports passing options through to stylesheet_link_tag" do
      AssetTrip.stub!(:manifest => AssetTrip::Manifest.new("foo.css" => "884695aafa07bf0c3e1f1fe578dd10d0"))
      stylesheet_link_asset("foo", :media => "print").should be_like(<<-HTML)
        <link href="/assets/88/4695aafa0/foo.css" media="print" rel="stylesheet" type="text/css" />
      HTML
    end

    it "works with the file extension specified" do
      AssetTrip.stub!(:manifest => AssetTrip::Manifest.new("foo.css" => "884695aafa07bf0c3e1f1fe578dd10d0"))
      stylesheet_link_asset("foo.css").should be_like(<<-HTML)
        <link href="/assets/88/4695aafa0/foo.css" media="screen" rel="stylesheet" type="text/css" />
      HTML
    end

    it "works with symbols" do
      AssetTrip.stub!(:manifest => AssetTrip::Manifest.new("foo.css" => "884695aafa07bf0c3e1f1fe578dd10d0"))
      stylesheet_link_asset(:foo).should be_like(<<-HTML)
        <link href="/assets/88/4695aafa0/foo.css" media="screen" rel="stylesheet" type="text/css" />
      HTML
    end

    it "raises an UnknownAssetError if it's not in the manifest" do
      AssetTrip.stub!(:manifest => AssetTrip::Manifest.new)
      lambda {
        stylesheet_link_asset("foo")
      }.should raise_error(AssetTrip::UnknownAssetError)
    end

    it "does not add file mtimes into the query string" do
      AssetTrip.stub!(:manifest => AssetTrip::Manifest.new("foo.css" => "884695aafa07bf0c3e1f1fe578dd10d0"))
      stub!(:rails_asset_id => "rails_asset_id")
      stylesheet_link_asset("foo").should_not include("rails_asset_id")
    end

    it "does not prevent mtimes from being added to other JavaScripts" do
      stub!(:rails_asset_id => "rails_asset_id")
      stylesheet_link_tag("foo").should include("rails_asset_id")
    end

    it "generates a link to the SSL version when necessary" do
      def request
        stub(:host => "localhost.com", :ssl? => true)
      end
      
      AssetTrip.stub!(:manifest => AssetTrip::Manifest.new("foo.css" => "884695aafa07bf0c3e1f1fe578dd10d0"))
      stylesheet_link_asset("foo").should be_like(<<-HTML)
        <link href="/assets/88/4695aafa0/foo.ssl.css" media="screen" rel="stylesheet" type="text/css" />
      HTML
    end
  end

  context "when bundling is disabled" do
    it "generates links to the unbundled Javascripts" do
      AssetTrip.stub!(:bundle => false)

      config = AssetTrip::Config.new do
        js_asset "foo" do
          include "first"
          include "second"
        end
      end
      AssetTrip.stub!(:config => config)

      javascript_include_asset("foo").should be_like(<<-HTML)
        <script src="http://localhost.com/__asset_trip__/javascripts/first.js" type="text/javascript"></script>
        <script src="http://localhost.com/__asset_trip__/javascripts/second.js" type="text/javascript"></script>
      HTML
    end

    it "generates links to the unbundled Stylesheets" do
      AssetTrip.stub!(:bundle => false)

      config = AssetTrip::Config.new do
        css_asset "all" do
          include "fonts"
          include "colors"
        end
      end
      AssetTrip.stub!(:config => config)

      stylesheet_link_asset("all").should be_like(<<-HTML)
        <link href="http://localhost.com/__asset_trip__/stylesheets/fonts.css" media="screen" rel="stylesheet" type="text/css" />
        <link href="http://localhost.com/__asset_trip__/stylesheets/colors.css" media="screen" rel="stylesheet" type="text/css" />
      HTML
    end
    
    context "when serving an https request" do
      def request
        stub(:host => "localhost.com", :ssl? => false, :protocol => "https://")
      end
      
      it "generates ssl links to the unbundled Stylesheets" do
        AssetTrip.stub!(:bundle => false)

        config = AssetTrip::Config.new do
          css_asset "all" do
            include "fonts"
            include "colors"
          end
        end
        AssetTrip.stub!(:config => config)

        stylesheet_link_asset("all").should be_like(<<-HTML)
          <link href="https://localhost.com/__asset_trip__/stylesheets/fonts.css" media="screen" rel="stylesheet" type="text/css" />
          <link href="https://localhost.com/__asset_trip__/stylesheets/colors.css" media="screen" rel="stylesheet" type="text/css" />
        HTML
      end
      
      it "generates ssl links to the unbundled Javascripts" do
        def request
          stub(:host => "localhost.com", :ssl? => false, :protocol => "https://")
        end

        AssetTrip.stub!(:bundle => false)

        config = AssetTrip::Config.new do
          js_asset "foo" do
            include "first"
            include "second"
          end
        end
        AssetTrip.stub!(:config => config)

        javascript_include_asset("foo").should be_like(<<-HTML)
          <script src="https://localhost.com/__asset_trip__/javascripts/first.js" type="text/javascript"></script>
          <script src="https://localhost.com/__asset_trip__/javascripts/second.js" type="text/javascript"></script>
        HTML
      end

    end

  end
end

