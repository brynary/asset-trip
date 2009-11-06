require "pathname"

module AssetTrip
  module Spec
    module PathnameExtensions
      def glob(*args)
        self.class.glob(self.join(*args))
      end
    end

    Pathname.send(:include, PathnameExtensions)
  end
end

class Time
  class << self
    alias_method :orig_new, :new

    undef :now
    def now
      defined?(@time) ? @time || orig_new : orig_new
    end

    alias_method :new, :now

    undef :freeze
    def freeze
      @time = now
      yield
    ensure
      @time = nil
    end

  end
end
