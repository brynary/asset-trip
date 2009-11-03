require "spec_helper"

describe "rake asset_trip:prune" do
  before do
    reset_filesystem!
    @old_pwd = Dir.pwd
    Dir.chdir(fixture_app)
  end

  after do
    Dir.chdir(@old_pwd)
  end

  it "removes assets not in the current Manifest"
  it "does not remove assets in the current Manifest"
end
