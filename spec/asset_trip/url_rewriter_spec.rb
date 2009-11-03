require "spec_helper"
require "action_controller"

describe AssetTrip::UrlRewriter do
  def self.it_rewrites_urls(path, mappings)
    original = mappings.keys.first
    result = mappings.values.first

    it "maps #{original} to #{result}" do
      output = AssetTrip::UrlRewriter.new("http", Pathname.new(path)).rewrite <<-CSS
        .foo { background: url(#{original}) }
      CSS

      output.should include("url(#{result})")
    end
  end

  describe "#rewrite" do
    it "applies asset hosts to CSS background images" do
      ActionController::Base.stub!(:asset_host => "http://cdn.example.com")

      output = AssetTrip::UrlRewriter.new("http").rewrite <<-CSS
        .foo { background: url(/foo.jpg) }
      CSS

      output.should include('url(http://cdn.example.com/foo.jpg)')
    end

    it "rewrites URLs with SSL when configured with SSL" do
      ActionController::Base.stub!(:asset_host => "http://cdn.example.com")

      output = AssetTrip::UrlRewriter.new("https").rewrite <<-CSS
        .foo { background: url(/foo.jpg) }
      CSS

      output.should include('url(https://cdn.example.com/foo.jpg)')
    end

    it "rewrites URLs without SSL when configured without SSL" do
      ActionController::Base.stub!(:asset_host => "http://cdn.example.com")

      output = AssetTrip::UrlRewriter.new("http").rewrite <<-CSS
        .foo { background: url(/foo.jpg) }
      CSS

      output.should include('url(http://cdn.example.com/foo.jpg)')
    end

    it "adds the protocol to the host when necessary" do
      ActionController::Base.stub!(:asset_host => "cdn.example.com")

      output = AssetTrip::UrlRewriter.new("http").rewrite <<-CSS
        .foo { background: url(/foo.jpg) }
      CSS

      output.should include('url(http://cdn.example.com/foo.jpg)')
    end

    it "replaces %d with a number in the asset host" do
      ActionController::Base.stub!(:asset_host => "http://cdn%d.example.com")

      output = AssetTrip::UrlRewriter.new("http").rewrite <<-CSS
        .foo { background: url(/foo.jpg) }
      CSS

      output.should include('url(http://cdn1.example.com/foo.jpg)')
    end

    it "doesn't modify background-image paths pointing to other servers" do
      ActionController::Base.stub!(:asset_host => "http://cdn.example.com")

      output = AssetTrip::UrlRewriter.new("http").rewrite <<-CSS
        .foo { background: url(http://google.com/foo.jpg) }
      CSS

      output.should include('url(http://google.com/foo.jpg)')
    end

    it "disregards leading and trailing whitespace and quotes" do
      ActionController::Base.stub!(:asset_host => "http://cdn.example.com")

      output = AssetTrip::UrlRewriter.new("http").rewrite <<-CSS
        .foo1 { background: url(  '/foo1.jpg'  ) }
        .foo2 { background: url(  "/foo2.jpg"  ) }
      CSS

      output.should include('url(http://cdn.example.com/foo1.jpg)')
      output.should include('url(http://cdn.example.com/foo2.jpg)')
    end

    it "doesn't modify paths for .htc files" do
      ActionController::Base.stub!(:asset_host => "http://cdn.example.com")

      output = AssetTrip::UrlRewriter.new("http").rewrite <<-CSS
        .foo { background: url(/foo.htc) }
      CSS

      output.should include('url(/foo.htc)')
    end

    it "works with asset host procs taking one arg" do
      ActionController::Base.stub!(:asset_host => Proc.new { |source|
        source.should_not be_nil
        "http://cdn.example.com"
      })

      output = AssetTrip::UrlRewriter.new("http").rewrite <<-CSS
        .foo { background: url(/foo.jpg) }
      CSS

      output.should include('url(http://cdn.example.com/foo.jpg)')
    end

    it "works with asset host procs taking two args" do
      ActionController::Base.stub!(:asset_host => Proc.new { |source, request|
        source.should_not be_nil
        request.should_not be_nil
        "http://cdn.example.com"
      })

      output = AssetTrip::UrlRewriter.new("http").rewrite <<-CSS
        .foo { background: url(/foo.jpg) }
      CSS

      output.should include('url(http://cdn.example.com/foo.jpg)')
    end

    it "works with no asset host" do
      ActionController::Base.stub!(:asset_host => nil)

      output = AssetTrip::UrlRewriter.new("http").rewrite <<-CSS
        .foo { background: url(/foo.jpg) }
      CSS

      output.should include('url(/foo.jpg)')
    end

    it "includes the file mtime for background images in the query string" do
      rewriter = AssetTrip::UrlRewriter.new("http")
      rewriter.stub!(:rails_asset_id => "123123123")

      output = rewriter.rewrite <<-CSS
        .foo { background: url(/foo.jpg) }
      CSS
      output.should include('url(/foo.jpg?123123123)')
    end

    it_rewrites_urls("/stylesheets/active_scaffold/default/stylesheet.css",
      "../../../images/./../images/goober/../spinner.gif" => "/images/spinner.gif")

    it_rewrites_urls("/stylesheets/active_scaffold/default/stylesheet.css",
      "../../../images/spinner.gif" => "/images/spinner.gif")

    it_rewrites_urls("/stylesheets/active_scaffold/default/./stylesheet.css",
      "../../../images/spinner.gif" => "/images/spinner.gif")

    it_rewrites_urls("/stylesheets/main.css",
      "image.gif" => "/stylesheets/image.gif")

    it_rewrites_urls("/stylesheets////default/main.css",
      "..//image.gif" => "/stylesheets/image.gif")

    it_rewrites_urls("/stylesheets/default/main.css",
      "/images/image.gif" => "/images/image.gif")
  end
end
