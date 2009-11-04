require "spec_helper"

describe AssetTrip::Stylesheet do
  describe "#contents" do
    setup_sandbox_app!

    before do
      AssetTrip::Compressor.stub!(:new => compressor)
      File.stub!(:read => "contents")
    end

    let(:compressor)   { stub(:compress => "compressed") }
    let(:url_rewriter) { stub(:rewrite => "rewritten") }

    it "compresses the contents" do
      AssetTrip::Compressor.should_receive(:new).with("css")
      asset = AssetTrip::Stylesheet.new(stub(), "all.css")
      asset.contents.should == "compressed"
    end

    it "only runs the Compressor once for the package" do
      compressor.should_receive(:compress).exactly(:once)
      asset = AssetTrip::Stylesheet.new(stub(), "all.css")
      asset.contents.should == "compressed"
    end

    it "rewrites the URLs" do
      AssetTrip::UrlRewriter.stub(:new => url_rewriter)
      url_rewriter.should_receive(:rewrite).with("contents")
      asset = AssetTrip::Stylesheet.new(stub(:resolve_file => "/fonts.css"), "all", ["fonts"])
      asset.contents
    end

    context "when the stylesheet is in the public directory" do
      it "does not initialize the UrlRewriter with a path" do
        AssetTrip::UrlRewriter.should_receive(:new).with("http").and_return(url_rewriter)
        asset = AssetTrip::Stylesheet.new(stub(:resolve_file => "/fonts.css"), "all", ["fonts"])
        asset.contents
      end
    end

    context "when the stylesheet is not in the public directory" do
      it "initializes the UrlRewriter with a path" do
        AssetTrip::UrlRewriter.should_receive(:new).with("http", Pathname.new("/fonts.css")).and_return(url_rewriter)
        public_path = fixture_app.join("public", "fonts.css")
        asset = AssetTrip::Stylesheet.new(stub(:resolve_file => public_path), "all", ["fonts"])
        asset.contents
      end
    end
  end
end
