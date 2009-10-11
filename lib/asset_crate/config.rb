module AssetCrate
  class Config

    attr_reader :crates

    def self.from_file(path)
      source = File.read(path)
      eval "AssetCrate::Config.new {( " + source + "\n )}"
    end

    def initialize(&block)
      instance_eval(&block)
    end

    def css_create(name)
      @crates ||= []
      @crates << name
    end

  end
end