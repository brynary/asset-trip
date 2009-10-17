module AssetTrip
  module Memoizable

    def self.memoized_ivar_for(symbol)
      "@_memoized_#{symbol.to_s.sub(/\?\Z/, '_query').sub(/!\Z/, '_bang')}".to_sym
    end

    def memoize(symbol)
      original_method = :"_unmemoized_#{symbol}"
      memoized_ivar = AssetTrip::Memoizable.memoized_ivar_for(symbol)

      raise "Already memoized #{symbol}" if method_defined?(original_method)
      alias_method original_method, symbol

      class_eval <<-EOS, __FILE__, __LINE__
        def #{symbol}(*args)                              # def mime_type(*args)
          if !defined?(#{memoized_ivar})                  #   if !defined?(@_memoized_mime_type)
            #{memoized_ivar} = #{original_method}(*args)  #     @_memoized_mime_type = _unmemoized_mime_type(*args)
          end                                             #   end
          #{memoized_ivar}                                #   @_memoized_mime_type
        end                                               # end
      EOS

      private symbol if private_method_defined?(original_method)
    end

  end
end