require "spec_helper"
require "action_controller"

describe AssetTrip::UrlRewriter do
  it "applies asset hosts to CSS background images" do
    ActionController::Base.stub!(:asset_host => "http://cdn.example.com")

    install_js_config <<-CONFIG
      css_blob "signup" do
        include "new"
      end
    CONFIG

    write_stylesheet("new.css", <<-STYLESHEET)
      .foo { background: url(/foo.jpg) }
    STYLESHEET
    bundle!

    blob("signup.css").should have_contents('url(http://cdn.example.com/foo.jpg)')
  end

  it "adds the protocol to the host when necessary" do
    ActionController::Base.stub!(:asset_host => "cdn.example.com")

    install_js_config <<-CONFIG
      css_blob "signup" do
        include "new"
      end
    CONFIG

    write_stylesheet("new.css", <<-STYLESHEET)
      .foo { background: url(/foo.jpg) }
    STYLESHEET
    bundle!

    blob("signup.css").should have_contents('url(http://cdn.example.com/foo.jpg)')
  end

  it "replaces %d with a number in the asset host" do
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

  it "doesn't modify background-image paths pointing to other servers" do
    ActionController::Base.stub!(:asset_host => "http://cdn.example.com")

    install_js_config <<-CONFIG
      css_blob "signup" do
        include "new"
      end
    CONFIG

    write_stylesheet("new.css", <<-STYLESHEET)
      .foo { background: url(http://google.com/foo.jpg) }
    STYLESHEET
    bundle!

    blob("signup.css").should have_contents('url(http://google.com/foo.jpg)')
  end

  it "disregards leading and trailing whitespace and quotes" do
    ActionController::Base.stub!(:asset_host => "http://cdn.example.com")

    install_js_config <<-CONFIG
      css_blob "signup" do
        include "new"
      end
    CONFIG

    write_stylesheet("new.css", <<-STYLESHEET)
      .foo1 { background: url(  '/foo1.jpg'  ) }
      .foo2 { background: url(  "/foo2.jpg"  ) }
    STYLESHEET
    bundle!

    blob("signup.css").should have_contents('url(http://cdn.example.com/foo1.jpg)')
    blob("signup.css").should have_contents('url(http://cdn.example.com/foo2.jpg)')
  end

  it "doesn't modify paths for .htc files" do
    ActionController::Base.stub!(:asset_host => "http://cdn.example.com")

    install_js_config <<-CONFIG
      css_blob "signup" do
        include "new"
      end
    CONFIG

    write_stylesheet("new.css", <<-STYLESHEET)
      .foo { background: url(/foo.htc) }
    STYLESHEET
    bundle!

    blob("signup.css").should have_contents('url(/foo.htc)')
  end

  it "includes the file mtime for background images in the query string"
  it "generates an SSL version of the file"
  it "generates a non-SSL version of the file"
end
