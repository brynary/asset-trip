require "spec_helper"

describe AssetTrip::LoadPath do
  describe "#==" do
    it "is not equal to other classes"
    it "is not equal to LoadPaths with different paths"
    it "is equal to LoadPaths with the same paths"
  end

  describe "#<<" do
    it "appends strings as Pathnames"
    it "appends Pathnames"
  end

  describe "#resolve" do
    it "returns an absolute path to an existing file"
    it "prefers finding files in earlier paths to later paths"
    it "raises an UnknownAssetError when resolving nil"
    it "raises an UnknownAssetError when the file is not found"
  end
end