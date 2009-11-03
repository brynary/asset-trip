require "spec_helper"

describe AssetTrip::Stylesheet do
  describe "bundle!" do
    it "writes a non-SSL stylesheet"
    it "writes a SSL stylesheet"
  end

  describe "#contents" do
    before do
      AssetTrip::Compressor.stub!(:new => compressor)
      File.stub!(:read => "contents")
    end

    let(:compressor) { stub(:compress => "compressed") }

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
      urlRewriter = AssetTrip::UrlRewriter.new
      AssetTrip::UrlRewriter.stub(:new).and_return(urlRewriter)
      urlRewriter.should_receive(:rewrite).with("")
      asset = AssetTrip::Stylesheet.new(stub(), "all.css")
      asset.contents
    end
  end
end
