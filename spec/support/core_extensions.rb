require "pathname"

module AssetCrate
  module Spec
    module PathnameExtensions
      def glob
        self.class.glob(self)
      end
    end

    Pathname.send(:include, PathnameExtensions)
  end
end
