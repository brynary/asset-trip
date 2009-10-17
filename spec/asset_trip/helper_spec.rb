require "spec_helper"

describe AssetTrip::Helper do
  describe "#javascript_include_blob" do
    it "supports passing options through to javascript_include_tag"
    it "does not add file mtimes into the query string"
  end

  describe "#stylesheet_link_blob" do
    it "supports passing options through to stylesheet_link_tag"
    it "generates a link to the SSL version when necessary"
    it "does not add file mtimes into the query string"
  end

  context "when bundling is disabled" do
    it "generates links to the files in the blob"
  end
end

