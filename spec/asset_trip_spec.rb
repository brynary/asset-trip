require "spec_helper"

describe AssetTrip do
  describe "#manifest" do
    context "when there is no manifest" do
      it "raises a NoManifestError" do
        lambda {
          AssetTrip.manifest
        }.should raise_error(AssetTrip::NoManifestError)
      end
    end
  end
end
