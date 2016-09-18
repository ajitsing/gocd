module GOCD
  class Server
    attr_reader :url

    def initialize(url)
      @url = url
    end
  end

  def self.server=(server)
    @server = server
  end

  def self.server
    @server
  end
end