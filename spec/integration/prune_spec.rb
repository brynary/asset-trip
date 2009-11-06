require "spec_helper"

describe "rake asset_trip:prune" do
  setup_sandbox_app!(:each)

  before do
    AssetTrip::Compressor.stub!(:new => DummyCompressor.new)
  end

  it "removes assets not in the current Manifest" do
    install_config <<-CONFIG
      js_asset "signup" do
        include "main.js"
      end
    CONFIG
    AssetTrip.bundle!
    AssetTrip.instance_variable_set(:@config, nil)
    write_javascript("main.js", 'alert("new.main");')
    AssetTrip.bundle!
    load fixture_app.join("config", "asset_trip", "manifest.rb")
    AssetTrip.prune!
    assets("signup.js").should have(1).item
  end

  it "does not remove assets in the current Manifest" do
    install_config <<-CONFIG
      js_asset "signup" do
        include "main.js"
      end
    CONFIG
    AssetTrip.bundle!
    load fixture_app.join("config", "asset_trip", "manifest.rb")
    AssetTrip.prune!
    assets("signup.js").should have(1).item
  end

  it "removes unknown files" do
    install_config <<-CONFIG
      js_asset "signup" do
        include "main.js"
      end
    CONFIG
    AssetTrip.bundle!

    File.open(assets_path.join("blah.jpg"), "w") do |f|
      f << "blah!"
    end

    load fixture_app.join("config", "asset_trip", "manifest.rb")
    AssetTrip.prune!
    assets("blah.jpg").should have(0).items
  end
end
