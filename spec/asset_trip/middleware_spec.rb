require "spec_helper"
require "rack/test"

describe AssetTrip::Middleware do
  include Rack::Test::Methods

  before do
    @old_pwd = Dir.pwd
    Dir.chdir(fixture_app)
  end

  after do
    Dir.chdir(@old_pwd)
  end

  def app
    AssetTrip::Middleware.new(lambda {
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    })
  end

  it "delegates requests to the inner app" do
    response = get "/"
    response.should be_not_found
  end

  it "serves up assets from the load paths" do
    response = get "/__asset_trip__/main.js"
    response.should be_ok
  end
end