module GOCD
  class Credentials
    def initialize(username, password)
      @username = username
      @password = password
    end

    def curl_credentials
      "#{@username}:#{@password}"
    end
  end

  def self.credentials=(credentials)
    @credentials = credentials
  end

  def self.credentials
    @credentials
  end
end