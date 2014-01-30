module Cielo24
  # Methods for authenticating.
  module Authentication
    
    # Public: Get a api token for this session.
    def login(username, password)
      data = get("/api/account/login", {username: username, password: password})
      data["ApiToken"]
    end
  end
end