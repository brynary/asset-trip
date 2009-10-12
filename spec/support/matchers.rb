module AssetCrate
  module Spec
    module Matchers

      def have_crate(name)
        simple_matcher("have crate") do |path|
          File.exist?(crates_path.join("**", name).glob.first)
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