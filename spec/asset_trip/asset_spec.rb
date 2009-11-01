require "spec_helper"

describe AssetTrip::Asset do
  class DummyProcessor
    def process(contents)
      return contents
    end
  end

  describe "#bundle!" do

  end

  describe "#md5sum" do
    it "calculates the MD5 if there are no files" do
      config = stub(:paths => [])
      asset = AssetTrip::Asset.new(config, DummyProcessor.new)
      asset.md5sum.should == "d41d8cd98f00b204e9800998ecf8427e"
    end

    it "calculates the MD5 for one file" do
      config = stub(:paths => [Pathname.new("foo.css")])
      File.stub!(:read => "contents")
      asset = AssetTrip::Asset.new(config, DummyProcessor.new)
      asset.md5sum.should == "98bf7d8c15784f0a3d63204441e1e2aa"
    end

    it "calculates the MD5 for multiple file" do
      config = stub(:paths => [Pathname.new("foo.css"), Pathname.new("bar.css")])
      File.stub!(:read => "contents")
      asset = AssetTrip::Asset.new(config, DummyProcessor.new)
      asset.md5sum.should == "a6082c83a20a90e5a2ab9f216961972f"
    end
  end
end
