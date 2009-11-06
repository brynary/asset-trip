module AssetTrip
  module Spec
    module SandboxHelper

      def setup_sandbox_app!(around = :all)
        before(around) do
          reset_filesystem!
          @old_pwd = Dir.pwd
          Dir.chdir(fixture_app)
        end

        after(around) do
          Dir.chdir(@old_pwd)
        end
      end

    end
  end
end
