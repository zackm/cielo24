module Cielo24

  # Class for interacting with the Cielo24 API.
  class Client
    include Cielo24::Authentication
    include Cielo24::Jobs

    attr_accessor :connection
    attr_accessor :token

    DEFAULT_URI = "https://api.cielo24.com"
    VERSION = 1
    VERIFY_MODE = nil

    # Public: Configures the connection.
    #
    # options - the configuration options for use with Cielo24.
    #     :username - The username to use for authentication.
    #     :password - The password to use for authentication.
    #     :api_key - The API key to use for authentication.
    #     :uri - The uri to use for requests. Defaults to the Cielo24 API URI.
    def self.configure(options = {})
      @options = {uri: DEFAULT_URI, version: VERSION, verify_mode: VERIFY_MODE}.merge(options)
    end

    # Internal: Our configuration settings for Cielo24.
    def self.options
      @options ||= {}
    end

    def initialize
      self.connection = connect

      login_options = {username: self.class.options[:username]}
      if self.class.options[:api_key]
        login_options['securekey'] = self.class.options[:api_key]
      else
        login_options['password'] = self.class.options[:password]
      end
      # Go ahead and set up the single use token for this session
      @token = log_in(login_options)
    end

    # Internal: Returns an HTTPClient connection object.
    def connect
      connection = HTTPClient.new
      connection.cookie_manager = nil

      unless self.class.options[:verify_mode] == nil
        connection.ssl_config.verify_mode = self.class.options[:verify_mode]
      end

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
        return response.body
      else
        # Cielo24 always returns error messages as JSON
        raise(JSON.parse(response.body)["ErrorComment"])
      end
    end

    # Internal: Makes a request to Cielo24 and returns JSON data
    def get_json(path, params)
      body = get(path, params)

      JSON.parse(body)
    end
  end
end