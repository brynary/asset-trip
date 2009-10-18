require "spec_helper"
require "rack/test"

describe AssetTrip::Middleware do
  include Rack::Test::Methods

  def app
    AssetTrip::Middleware.new(lambda {
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    })
  end

  it "calls down the chain if the URL root is not known" do
    response = get "/"
    response.should be_not_found
  end

  it "404s if the URL root is known but it can't find the file" do
    response = get "/__asset_trip__/not_found.js"
    response.should be_not_found
  end

  it "serves assets from the load paths" do
    response = get "/__asset_trip__/main.js"
    response.should be_ok
  end

  it "sets the Last-Modified header" do
    path = File.join(Dir.pwd, "app", "javascripts", "main.js")
    response = get "/__asset_trip__/main.js"
    response["Last-Modified"].should == File.mtime(path).httpdate
  end

  it "does not allow directory traversal" do
    response = get "/__asset_trip__/../main.js"
    response.should be_forbidden
  end

  it "does not allow directory traversal with encoded periods" do
    response = get "/__asset_trip__/%2E%2E/main.js"
    response.should be_forbidden
  end

  it "serves files with URL encoded filenames" do
    response = get "/__asset_trip__/%6D%61%69%6E.js" # main.js
    response.should be_ok
  end
end