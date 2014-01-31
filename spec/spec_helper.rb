require_relative "../lib/cielo24"

if ENV["CIELO24_SANDBOX"]
  Cielo24::Client.configure(username: ENV["CIELO24_SANDBOX_USERNAME"], 
      password: ENV["CIELO24_SANDBOX_PASSWORD"], 
      uri: "https://sandbox.cogi.com", verify_mode: OpenSSL::SSL::VERIFY_NONE)
end


module Cielo24
  module SpecHelpers

    # Internal: Returns whether or not we're testing against the sandbox.
    def test_sandbox?
      !ENV["CIELO24_SANDBOX"].nil?
    end

    # Internal: Stubs the get_json method unless we're testing against the sandbox.
    # 
    # path - The api path to stub.
    # value - The value to return from the stubbed call.
    #
    # Examples:
    #     stub_get_json("/api/job/new", {"JobId" => "12345"})
    #     => get_json returns {"JobId" => "12345"}
    def stub_get_json(path, value)
      unless test_sandbox?
        Cielo24::Client.any_instance.stub(:get_json).with(path, an_instance_of(Hash)).and_return(value)
      end
    end

    # Internal: STubs the get method unless we're testing against the sandbox.
    #
    # path - The api path to stub.
    # value - The value to return from the stubbed call.
    #
    # Examples:
    #    stub_get("/api/job/get_caption", "SOME CAPTION DATA")
    #    => get returns "SOME CAPTION DATA"
    def stub_get(path, value)
      unless test_sandbox?
        Cielo24::Client.any_instance.stub(:get).with(path, an_instance_of(Hash)).and_return(value)
      end
    end
  end
end

RSpec.configure do |config|
  config.include Cielo24::SpecHelpers

  # Stub out logging in if needed
  config.before(:each) do
    unless test_sandbox?
      Cielo24::Client.any_instance.stub(:log_in).and_return("FOOBARTOKEN")
    end
  end
end