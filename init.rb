if File.exist?(Rails.root.join("config", "asset_trip", "manifest.rb"))
  require Rails.root.join("config", "asset_trip", "manifest")
end
