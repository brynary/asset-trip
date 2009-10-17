require "spec_helper"

describe AssetTrip::UrlRewriter do
  it "rewrites relative image paths to be absolute"
  it "applies asset hosts to CSS background images"
  it "doesn't modify background-image paths pointing to other servers"
  it "doesn't modify paths for .htc files"
  it "includes the file mtime for background images in the query string"
  it "generates an SSL version of the file"
  it "generates a non-SSL version of the file"
end
