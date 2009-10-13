module BlobBundler
  module Spec
    module Matchers

      def have_blob(name)
        simple_matcher("have blob") do |path|
          File.exist?(blobs_path.glob("**", name).first)
        end
      end

      def have_directory(name)
        simple_matcher("have directory") do |path|
          matches = path.glob("**", name)
          matches.any? { |path| File.directory?(path) }
        end
      end

      def have_contents(text)
        simple_matcher("have contents") do |path|
          File.read(path).include?(text)
        end
      end

    end
  end
end