require "asset_crate"

Dir[File.join(File.dirname(__FILE__), 'support', '*.rb')].each do |file|
  require file
end

Spec::Runner.configure do |config|
  config.include AssetCrate::Spec::Helpers
  config.include AssetCrate::Spec::Matchers
  config.include AssetCrate::Spec::PathUtils
  
  config.before do
    reset_filesystem!
  end
end