module Cielo24

  # Class for interacting with the Cielo24 API.
  class Client
    include Cielo24::Authentication
    include Cielo24::Jobs

    attr_accessor :connection
    attr_accessor :token

    DEFAULT_URI = "https://api.cielo24.com"
    VERSION = 1

    # Public: Configures the connection.
    #
    # options - the configuration options for use with Cielo24.
    #     :username - The username to use for authentication.
    #     :password - The password to use for authentication.
    #     :uri - The uri to use for requests. Defaults to the Cielo24 API URI.
    def self.configure(options = {})
      @options = {uri: DEFAULT_URI, version: VERSION}.merge(options)
    end

    # Internal: Our configuration settings for Cielo24.
    def self.options
      @options ||= {}
    end

    def initialize
      self.connection = connect

      # Go ahead and set up the single use token for this session
      @token = login(self.class.options[:username], self.class.options[:password])
    end

    # Internal: Returns an HTTPClient connection object.
    def connect
      connection = HTTPClient.new
      connection.cookie_manager = nil

      return connection
    end

    # Internal: Makes a get request with the given parameters.
    #
    # path - The path to request.
    # params - The parameters to include with the request.
    #
    # Returns the JSON for the response we received.
    def get(path, params = {})
      uri = URI(self.class.options[:uri])
      uri.path = path

      # add api version to each request
      params = {v: self.class.options[:version]}.merge(params)

      # add token if possible
      if token
        params = {api_token: token}.merge(params)
      end

      response = connection.get(uri, params)
      if response.status_code == 200
        return JSON.parse(response.body)
      else
        raise(JSON.parse(response.body)["ErrorComment"])
      end
    end
  end
end