module AssetTrip
  class SSLStylesheet < Stylesheet

    def name
      "#{@name}.ssl.css"
    end

  private

    def url_scheme
      "https"
    end

  end
end
