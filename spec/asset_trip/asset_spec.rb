require "spec_helper"

describe AssetTrip::Asset do
  describe "#bundle!" do
    it "creates the directory for the asset"
    it "writes the contents to the file"
    it "splits the MD5 into two nested directories"
  end

  describe "#md5sum" do
    before do
      AssetTrip::Compressor.stub!(:new => DummyCompressor.new)
      File.stub!(:read => "contents")
    end

    class DummyCompressor
      def compress(contents)
        return contents
      end
    end

    it "calculates the MD5 if there are no files" do
      asset = AssetTrip::Javascript.new(stub, "asset")
      asset.md5sum.should == "d41d8cd98f00b204e9800998ecf8427e"
    end

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
