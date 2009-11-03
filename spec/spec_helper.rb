require "asset_trip"

Dir[File.join(File.dirname(__FILE__), 'support', '*.rb')].each do |file|
  require file
end

class DummyCompressor
  def compress(contents)
    return contents
  end
end

Spec::Runner.configure do |config|
  config.include AssetTrip::Spec::Helpers
  config.include AssetTrip::Spec::Matchers
  config.include AssetTrip::Spec::PathUtils

  config.before do
    # TODO: Is there a better way to accomodate this concern?
    AssetTrip.instance_variable_set(:@config, nil)
  end
end
