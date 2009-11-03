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

    it "sends the uncompressed contents via STDIN" do
      stdin = stub(:close => nil)

      POpen4.stub!(:popen4) do |command, block|
        block.call(stub(:read => "STDOUT"), stub(:read => "STDERR"), stdin)
        stub(:success? => true)
      end

      stdin.should_receive(:puts).with("a { color: red }")
      compressor.compress("a { color: red }").should == "STDOUT"
    end

    it "returns the STDOUT from the java process" do
      POpen4.stub!(:popen4) do |command, block|
        block.call(stub(:read => "STDOUT"), stub(:read => "STDERR"), stub(:puts => nil, :close => nil))
        stub(:success? => true)
      end
      compressor.compress("a { color: red }").should == "STDOUT"
    end

    it "raises a CompressorError if the java process is not successful" do
      POpen4.stub!(:popen4 => stub(:success? => false))
      lambda {
        compressor.compress("a { color: red }")
      }.should raise_error(AssetTrip::CompressorError)
    end
  end
end
