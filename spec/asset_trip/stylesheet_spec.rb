require "spec_helper"

describe AssetTrip::Stylesheet do
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

    it "rewrites the URLs"
  end
end
