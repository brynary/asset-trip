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

      def have_asset(name)
        simple_matcher("have asset") do |path|
          File.exist?(assets_path.glob("**", name).first)
        end
      end

      def have_directory(name)
        simple_matcher("have directory") do |path|
          matches = path.glob("**", name)
          matches.any? { |path| File.directory?(path) }
        end
      end

      class HaveContents
        def initialize(text)
          @text = text
        end

        def matches?(path)
          @path = path
          @actual = File.read(path)
          @actual.include?(@text)
        end

        def failure_message
          "expected #{@path}\n#{@actual}\nto include\n#{@text}"
        end

        def negative_failure_message
          "expected #{@path}\n#{@actual}\nto not include\n#{@text}"
        end
      end

      def have_contents(text)
        HaveContents.new(text)
      end

    end
  end
end
