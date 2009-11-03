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

  xit "removes assets not in the current Manifest" do
    install_js_config <<-CONFIG
      js_asset "signup" do
        include "main.js"
      end
    CONFIG
    AssetTrip.bundle!
    AssetTrip.instance_variable_set(:@config, nil)
    write_javascript("main.js", 'alert("new.main");')
    AssetTrip.bundle!
    assets("signup.js").should have(2).items
    AssetTrip.prune!
    assets("signup.js").should have(1).item
  end

  it "does not remove assets in the current Manifest"
end
