require "spec_helper"

describe AssetTrip::Asset do
  describe "#bundle!" do

  end

  describe "#md5sum" do
    it "calculates the MD5 if there are no files" do
      config = stub(:paths => [])
      asset = AssetTrip::Asset.new(config)
      asset.md5sum.should == "d41d8cd98f00b204e9800998ecf8427e"
    end

    it "calculates the MD5 for one file" do
      config = stub(:paths => [Pathname.new("foo.css")])
      File.stub!(:read => "contents")
      asset = AssetTrip::Asset.new(config)
      asset.md5sum.should == "98bf7d8c15784f0a3d63204441e1e2aa"
    end

    it "calculates the MD5 for multiple file" do
      config = stub(:paths => [Pathname.new("foo.css"), Pathname.new("bar.css")])
      File.stub!(:read => "contents")
      asset = AssetTrip::Asset.new(config)
      asset.md5sum.should == "237c43254a0799392cac71f795d9250e"
    end
  end
end
