require "pathname"

module BlobBundler
  module Spec
    module PathnameExtensions
      def glob(*args)
        self.class.glob(self.join(*args))
      end
    end

    Pathname.send(:include, PathnameExtensions)
  end
end
