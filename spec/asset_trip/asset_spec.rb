require "spec_helper"

describe AssetTrip::Asset do
  before do
    AssetTrip::Compressor.stub!(:new => DummyCompressor.new)
    File.stub!(:read => "contents")
  end

  describe "#bundle!" do
    it "splits the MD5 into two nested directories" do
      path = AssetTrip.assets_path.join("98", "bf7d8c157", "asset.js")
      AssetTrip::FileWriter.should_receive(:new).with(path).and_return(stub(:write! => nil))
      asset = AssetTrip::Javascript.new(stub(:resolve_file => "foo.js"), "asset", [Pathname.new('foo.js')])
      asset.bundle!
    end

    it "writes the contents to the file" do
      writer = stub
      writer.should_receive(:write!).with("contents")
      AssetTrip::FileWriter.stub!(:new => writer)
      asset = AssetTrip::Javascript.new(stub(:resolve_file => "foo.js"), "asset", [Pathname.new("foo.js")])
      asset.bundle!
    end
  end

  describe "#md5sum" do
    it "calculates the MD5 for one file" do
      asset = AssetTrip::Javascript.new(stub(:resolve_file => "foo"), "asset") do
        include "foo"
      end
      asset.md5sum.should == "98bf7d8c15784f0a3d63204441e1e2aa"
    end

    it "calculates the MD5 for multiple file" do
      asset = AssetTrip::Javascript.new(stub(:resolve_file => "foo"), "asset") do
        include "foo"
        include "bar"
      end
      asset.md5sum.should == "237c43254a0799392cac71f795d9250e"
    end
  end
end
