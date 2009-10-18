require "spec_helper"
require "action_controller"

describe AssetTrip::UrlRewriter do
  it "applies asset hosts to CSS background images" do
    ActionController::Base.stub!(:asset_host => "http://cdn.example.com")

    output = AssetTrip::UrlRewriter.new.rewrite <<-CSS
      .foo { background: url(/foo.jpg) }
    CSS

    output.should include('url(http://cdn.example.com/foo.jpg)')
  end

  it "adds the protocol to the host when necessary" do
    ActionController::Base.stub!(:asset_host => "cdn.example.com")

    output = AssetTrip::UrlRewriter.new.rewrite <<-CSS
      .foo { background: url(/foo.jpg) }
    CSS

    output.should include('url(http://cdn.example.com/foo.jpg)')
  end

  it "replaces %d with a number in the asset host" do
    ActionController::Base.stub!(:asset_host => "http://cdn%d.example.com")

    output = AssetTrip::UrlRewriter.new.rewrite <<-CSS
      .foo { background: url(/foo.jpg) }
    CSS

    output.should include('url(http://cdn1.example.com/foo.jpg)')
  end

  it "doesn't modify background-image paths pointing to other servers" do
    ActionController::Base.stub!(:asset_host => "http://cdn.example.com")

    output = AssetTrip::UrlRewriter.new.rewrite <<-CSS
      .foo { background: url(http://google.com/foo.jpg) }
    CSS

    output.should include('url(http://google.com/foo.jpg)')
  end

  it "disregards leading and trailing whitespace and quotes" do
    ActionController::Base.stub!(:asset_host => "http://cdn.example.com")

    output = AssetTrip::UrlRewriter.new.rewrite <<-CSS
      .foo1 { background: url(  '/foo1.jpg'  ) }
      .foo2 { background: url(  "/foo2.jpg"  ) }
    CSS

    output.should include('url(http://cdn.example.com/foo1.jpg)')
    output.should include('url(http://cdn.example.com/foo2.jpg)')
  end

  it "doesn't modify paths for .htc files" do
    ActionController::Base.stub!(:asset_host => "http://cdn.example.com")

    output = AssetTrip::UrlRewriter.new.rewrite <<-CSS
      .foo { background: url(/foo.htc) }
    CSS

    output.should include('url(/foo.htc)')
  end

  it "includes the file mtime for background images in the query string"
  it "generates an SSL version of the file"
  it "generates a non-SSL version of the file"
end
