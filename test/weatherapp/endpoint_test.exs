defmodule Weatherapp.EndpointTest do
  @moduledoc """
    test
  """
  use ExUnit.Case, async: true
  use Plug.Test

  alias Weatherapp.Endpoint

  @opts Endpoint.init([])

  describe "/" do
    test "it returns 200 with a message" do
      # Create a test connection
      conn = conn(:get, "/", %{})

      # Invoke the plug
      conn = Endpoint.call(conn, @opts)

      # Assert the response
      assert conn.status == 200
    end
  end

  test "it returns 404 when no route matches" do
    # Create a test connection
    conn = conn(:get, "/fail")

    # Invoke the plug
    conn = Endpoint.call(conn, @opts)

    # Assert the response
    assert conn.status == 404
  end

end
