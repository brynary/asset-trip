require "asset_trip"

Dir[File.join(File.dirname(__FILE__), 'support', '*.rb')].each do |file|
  require file
end

Spec::Runner.configure do |config|
  config.include AssetTrip::Spec::Helpers
  config.include AssetTrip::Spec::Matchers
  config.include AssetTrip::Spec::PathUtils

  config.before do
    reset_filesystem!
    @old_pwd = Dir.pwd
    Dir.chdir(fixture_app)
  end

  config.after do
    Dir.chdir(@old_pwd)
  end
end