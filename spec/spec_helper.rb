require "blob_bundler"

Dir[File.join(File.dirname(__FILE__), 'support', '*.rb')].each do |file|
  require file
end

Spec::Runner.configure do |config|
  config.include BlobBundler::Spec::Helpers
  config.include BlobBundler::Spec::Matchers
  config.include BlobBundler::Spec::PathUtils
  
  config.before do
    reset_filesystem!
  end
end