namespace :assets do
  desc "Bundle assets"
  task :bundle => :environment do
    AssetTrip.bundle!
  end
end