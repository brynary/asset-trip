require "spec_helper"

describe "an Asset that rewrites URLs", :shared => true do
  setup_sandbox_app!

  let(:url_rewriter) { stub(:rewrite => "rewritten") }

  before do
    AssetTrip::Compressor.stub!(:new => stub(:compress => "compressed"))
    File.stub!(:read => "contents")
  end

  it "rewrites the URLs" do
    AssetTrip::UrlRewriter.stub(:new => url_rewriter)
    url_rewriter.should_receive(:rewrite).with("contents")
    described_class.new(stub(:resolve_file => "/fonts.css"), "all", ["fonts"]).contents
  end

  context "when the stylesheet is in the public directory" do
    it "does not initialize the UrlRewriter with a path" do
      AssetTrip::UrlRewriter.should_receive(:new).with(url_scheme).and_return(url_rewriter)
      described_class.new(stub(:resolve_file => "/fonts.css"), "all", ["fonts"]).contents
    end
  end

  context "when the stylesheet is not in the public directory" do
    it "initializes the UrlRewriter with a path" do
      AssetTrip::UrlRewriter.should_receive(:new).with(url_scheme, Pathname.new("/fonts.css")).and_return(url_rewriter)
      public_path = fixture_app.join("public", "fonts.css")
      described_class.new(stub(:resolve_file => public_path), "all", ["fonts"]).contents
    end
  end
end

describe "an Asset that compresses", :shared => true do
  setup_sandbox_app!

  let(:compressor) { stub(:compress => "compressed") }

  before do
    AssetTrip::Compressor.stub!(:new => compressor)
    File.stub!(:read => "contents")
  end

  it "compresses the contents" do
    AssetTrip::Compressor.should_receive(:new).with("css")
    described_class.new(stub(:resolve_file => "foo.css"), "all.css", [Pathname.new('foo.css')]).contents.should == "compressed"
  end

  it "only runs the Compressor once for the package" do
    compressor.should_receive(:compress).exactly(:once)
    described_class.new(stub(:resolve_file => "foo.css"), "all.css", [Pathname.new('foo.css')]).contents.should == "compressed"
  end
end

describe AssetTrip::Stylesheet do
  let(:url_scheme) { "http" }
  it_should_behave_like "an Asset that rewrites URLs"
end

describe AssetTrip::Stylesheet do
  it_should_behave_like "an Asset that compresses"
end

