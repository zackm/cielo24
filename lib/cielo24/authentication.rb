module Cielo24
  # Methods for authenticating.
  module Authentication
    
    # Public: Get a api token for this session.
    #
    # options - a Hash with either of the following sets of keys:
    #     username, password
    #     username, securekey
    def log_in(options)
      data = get_json("/api/account/login", options)
      data["ApiToken"]
    end
  end
end