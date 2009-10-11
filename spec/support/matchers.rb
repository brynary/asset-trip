module AssetCrate
  module Spec
    module Matchers

      def have_crate(name)
        simple_matcher("have crate") do |path|
          file = path.join("public", "crates", name)
          File.exist?(file)
        end
      end

    end
  end
end