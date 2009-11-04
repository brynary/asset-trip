require "spec_helper"

describe AssetTrip::ManifestWriter do
  describe "#write!" do
    it "writes a Ruby file" do
      path = AssetTrip.app_root.join("config", "asset_trip", "manifest.rb")
      AssetTrip::FileWriter.should_receive(:new).with(path).and_return(stub(:write! => nil))
      manifest_writer = AssetTrip::ManifestWriter.new([])
      manifest_writer.write!
    end

    it "initializes @manifest in AssetTrip to be a hash" do
      file_writer = stub
      file_writer.should_receive(:write!).with(<<-SRC)
module AssetTrip
  @manifest = Manifest.new
end
      SRC
      AssetTrip::FileWriter.stub!(:new => file_writer)
      manifest_writer = AssetTrip::ManifestWriter.new([])
      manifest_writer.write!
    end

    it "stores the MD5 of each asset as the value in the hash" do
      file_writer = stub
      file_writer.should_receive(:write!).with(/@manifest\["foo.js"\] = "fa9bac2ae2d"/)
      AssetTrip::FileWriter.stub!(:new => file_writer)
      manifest_writer = AssetTrip::ManifestWriter.new([stub(:asset, :name => "foo.js", :md5sum => "fa9bac2ae2d19ec2942a718253c55862")])
      manifest_writer.write!
    end
  end
end
