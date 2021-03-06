# frozen_string_literal: true

require "test_helper"

class Clerk::Resources::ClientsTest < Minitest::Test
  def mock_sdk
    faraday = Faraday.new do |faraday|
      faraday.adapter :test do |stub|
        stub.get("/clients") { json_ok("all_clients") }
        stub.get("/clients/client_1") { json_ok("client_1") }
        stub.post("/clients/verify") { json_ok("client_1") }
      end
    end

    ::Clerk::SDK.new(connection: faraday)
  end

  def test_all_clients
    sess = mock_sdk.clients.all
    assert_equal ["client"], sess.map { |h| h.dig("object") }
  end

  def test_find_client
    sess = mock_sdk.clients.find("client_1")
    assert_equal "client", sess["object"]
    assert_equal "client_1", sess["id"]
  end

  def test_verify_client
    sess = mock_sdk.clients.verify_token("token_1")
    assert_equal "client", sess["object"]
    assert_equal "client_1", sess["id"]
  end
end
