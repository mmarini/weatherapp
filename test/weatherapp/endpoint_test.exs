defmodule Weatherapp.EndpointTest do
  @moduledoc """
    test
  """
  use ExUnit.Case, async: false
  use Plug.Test

  alias Weatherapp.Cache.Cache
  alias Weatherapp.Endpoint

  @opts Endpoint.init([])

  describe "/weather" do
    test "it returns 200 with a message" do
      # Create a test connection
      conn = conn(:get, "/weather", %{})

      # Add weather to the cache
      record = %Weatherapp.Records.Weather{temperature_degrees: 50, wind_speed: 50}

      Cache.start()
      Cache.insert(record)

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
