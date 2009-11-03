namespace :assets do
  desc "Bundle assets"
  task :bundle => :environment do
    AssetTrip.bundle!
  end

  desc "Prune assets"
  task :prune => :environment do
    AssetTrip.prune!
  end
end