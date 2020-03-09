defmodule Weatherapp.Cache.CacheTest do
  @moduledoc """
    Tests for the Open Weather Map service
  """

  use ExUnit.Case, async: false

  alias Weatherapp.Cache.Cache

  test "reads back from the cached" do
    record = %Weatherapp.Records.Weather{temperature_degrees: 20, wind_speed: 10}

    Cache.start()
    Cache.insert(record)
    assert(Cache.read == record)
  end

  test "does not return a cached record due to expiry" do
    record = %Weatherapp.Records.Weather{temperature_degrees: 20, wind_speed: 10}

    sleep_for = Cache.expiry_time_seconds() + 1

    Cache.start()
    Cache.insert(record)
    Process.sleep(sleep_for * 1000)
    assert(Cache.read == nil)
  end

  test "clears the cache" do
    record = %Weatherapp.Records.Weather{temperature_degrees: 20, wind_speed: 10}

    Cache.start()
    Cache.insert(record)
    Cache.clear()
    assert(Cache.read == nil)
  end

end
