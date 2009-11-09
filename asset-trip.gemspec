# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{asset-trip}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bryan Helmkamp"]
  s.date = %q{2009-11-09}
  s.description = %q{Asset Trip bundles JavaScript and CSS files at deploy time. The assets are
then served from a Git-esque object store in the application's public
directory.}
  s.email = %q{bryan@brynary.com}
  s.extra_rdoc_files = [
    "History.txt",
    "README.rdoc",
    "MIT-LICENSE.txt"
  ]
  s.files = [
    ".gitignore",
    "History.txt",
    "MIT-LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "Thorfile",
    "asset-trip.gemspec",
    "init.rb",
    "lib/asset_trip.rb",
    "lib/asset_trip/asset.rb",
    "lib/asset_trip/compressor.rb",
    "lib/asset_trip/config.rb",
    "lib/asset_trip/file_writer.rb",
    "lib/asset_trip/helper.rb",
    "lib/asset_trip/javascript.rb",
    "lib/asset_trip/load_path.rb",
    "lib/asset_trip/manifest.rb",
    "lib/asset_trip/manifest_writer.rb",
    "lib/asset_trip/memoizable.rb",
    "lib/asset_trip/middleware.rb",
    "lib/asset_trip/ssl_stylesheet.rb",
    "lib/asset_trip/stylesheet.rb",
    "lib/asset_trip/url_rewriter.rb",
    "spec/asset_trip/asset_spec.rb",
    "spec/asset_trip/compressor_spec.rb",
    "spec/asset_trip/config_spec.rb",
    "spec/asset_trip/helper_spec.rb",
    "spec/asset_trip/javascript_spec.rb",
    "spec/asset_trip/load_path_spec.rb",
    "spec/asset_trip/manifest_writer_spec.rb",
    "spec/asset_trip/middleware_spec.rb",
    "spec/asset_trip/ssl_stylesheet_spec.rb",
    "spec/asset_trip/stylesheet_spec.rb",
    "spec/asset_trip/url_rewriter_spec.rb",
    "spec/asset_trip_spec.rb",
    "spec/fixtures/app/javascripts/main.js",
    "spec/fixtures/app/javascripts/main/new.js",
    "spec/fixtures/app/javascripts/signup.js",
    "spec/fixtures/app/stylesheets/new.css",
    "spec/fixtures/config/asset_trip/assets.rb",
    "spec/integration/bundle_spec.rb",
    "spec/integration/prune_spec.rb",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "spec/support/core_extensions.rb",
    "spec/support/helpers.rb",
    "spec/support/matchers.rb",
    "spec/support/path_utils.rb",
    "spec/support/sandbox_helper.rb",
    "tasks/asset_trip.rake",
    "vendor/yuicompressor-2.4.2.jar"
  ]
  s.homepage = %q{http://github.com/brynary/asset-trip}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Rails asset bundling plugin that will expand your mind}
  s.test_files = [
    "spec/asset_trip/asset_spec.rb",
    "spec/asset_trip/compressor_spec.rb",
    "spec/asset_trip/config_spec.rb",
    "spec/asset_trip/helper_spec.rb",
    "spec/asset_trip/javascript_spec.rb",
    "spec/asset_trip/load_path_spec.rb",
    "spec/asset_trip/manifest_writer_spec.rb",
    "spec/asset_trip/middleware_spec.rb",
    "spec/asset_trip/ssl_stylesheet_spec.rb",
    "spec/asset_trip/stylesheet_spec.rb",
    "spec/asset_trip/url_rewriter_spec.rb",
    "spec/asset_trip_spec.rb",
    "spec/fixtures/config/asset_trip/assets.rb",
    "spec/integration/bundle_spec.rb",
    "spec/integration/prune_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/core_extensions.rb",
    "spec/support/helpers.rb",
    "spec/support/matchers.rb",
    "spec/support/path_utils.rb",
    "spec/support/sandbox_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
