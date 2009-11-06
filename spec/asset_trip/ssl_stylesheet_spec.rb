require "spec_helper"
require "asset_trip/stylesheet_spec"

describe AssetTrip::SSLStylesheet do
  let(:url_scheme) { "https" }
  it_should_behave_like "an Asset that rewrites URLs"
end

describe AssetTrip::SSLStylesheet do
  it_should_behave_like "an Asset that compresses"
end
