module AssetTrip
  module Spec
    module Matchers
      
      class BeLike
        def initialize(expected)
          @expected = expected
        end

        def matches?(actual)
          @actual = actual
          @expected.gsub(/\s+/, ' ').strip == @actual.gsub(/\s+/, ' ').strip
        end

        def failure_message
          "expected\n#{@actual}\nto be like\n#{@expected}"
        end

        def negative_failure_message
          "expected\n#{@actual}\nto be unlike\n#{@expected}"
        end
      end

      def be_like(expected)
        BeLike.new(expected)
      end

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