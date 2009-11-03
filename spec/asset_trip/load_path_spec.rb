require "spec_helper"

describe AssetTrip::LoadPath do
  describe "#==" do
    it "is not equal to other classes" do
      AssetTrip::LoadPath.new.should_not == String.new
    end

    it "is not equal to LoadPaths with different paths" do
      AssetTrip::LoadPath.new(["app/javascripts"]).should_not ==
      AssetTrip::LoadPath.new(["app/stylesheets"])
    end

    it "is equal to LoadPaths with the same paths" do
      AssetTrip::LoadPath.new(["app/javascripts"]).should ==
      AssetTrip::LoadPath.new(["app/javascripts"])
    end
  end

  describe "#<<" do
    it "appends strings as Pathnames" do
      load_path = AssetTrip::LoadPath.new
      load_path << "app/javascripts"
      load_path.should == AssetTrip::LoadPath.new([Pathname.new("app/javascripts")])
    end

    it "appends Pathnames" do
      load_path = AssetTrip::LoadPath.new
      load_path << Pathname.new("app/javascripts")
      load_path.should == AssetTrip::LoadPath.new([Pathname.new("app/javascripts")])
    end
  end

  describe "#resolve" do
    it "returns an absolute path to an existing file" do
      File.stub!(:exist? => true)
      load_path = AssetTrip::LoadPath.new(["/"])
      load_path.resolve("found.css").should == Pathname.new("/found.css")
    end

    it "prefers finding files in earlier paths to later paths" do
      File.stub!(:exist? => true)
      load_path = AssetTrip::LoadPath.new(["/usr", "/"])
      load_path.resolve("found.css").should == Pathname.new("/usr/found.css")
    end

    it "raises an UnknownAssetError when resolving nil" do
      load_path = AssetTrip::LoadPath.new
      lambda {
        load_path.resolve(nil)
      }.should raise_error(AssetTrip::UnknownAssetError)
    end

    it "raises an UnknownAssetError when the file is not found" do
      load_path = AssetTrip::LoadPath.new
      lambda {
        load_path.resolve("missing.jpg")
      }.should raise_error(AssetTrip::UnknownAssetError)
    end
  end
end
