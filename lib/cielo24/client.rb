module Cielo24

  # Class for interacting with the Cielo24 API.
  class Client
    include Cielo24::Authentication

    attr_accessor :connection

    DEFAULT_URI = "https://api.cielo24.com"

    # Public: Configures the connection.
    #
    # options - the configuration options for use with Cielo24.
    #     :username - The username to use for authentication.
    #     :password - The password to use for authentication.
    #     :uri - The uri to use for requests. Defaults to the Cielo24 API URI.
    def self.configure(options = {})
      @options = {uri: DEFAULT_URI}.merge(options)
    end

    # Internal: Our configuration settings for Cielo24.
    def self.options
      @options ||= {}
    end

    def initialize
      self.connection = connect
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
    # Returns an HTTP::Message for the response.
    def get(path, params = {})
      uri = URI(self.class.options[:uri])
      uri.path = path
      connection.get(uri, params)
    end
  end
end