require "spec_helper"

describe AssetTrip::Compressor do
  let(:compressor) do
    AssetTrip::Compressor.new(Pathname.new("css"))
  end

  describe "#compress" do
    it "builds a command with the proper --type option" do
      POpen4.should_receive(:popen4).with(/--type css/).and_return(stub(:success? => true))
      compressor.compress("a { color: red }")
    end

    it "builds a command to run the vendored jar file" do
      POpen4.should_receive(:popen4).with(/java -jar .*vendor\/yuicompressor-2.4.2.jar/).and_return(stub(:success? => true))
      compressor.compress("a { color: red }")
    end

    it "returns the STDOUT from the java process"

    it "raises a CompressorError if the java process is not successful" do
      POpen4.stub!(:popen4 => stub(:success? => false))
      lambda {
        compressor.compress("a { color: red }")
      }.should raise_error(AssetTrip::CompressorError)
    end
  end
end
