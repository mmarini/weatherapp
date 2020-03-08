defmodule Weatherapp.Service.Providers.CacheTest do
  @moduledoc """
    Tests for the Open Weather Map service
  """

  use ExUnit.Case, async: false

  alias Weatherapp.Cache.Cache
  alias Weatherapp.Service.Providers.Cache, as: ProviderCache

  test "get successful request" do
    record = %Weatherapp.Records.Weather{temperature_degrees: 50, wind_speed: 40}

    Cache.start()
    Cache.insert(record)

    {:ok, weather} = ProviderCache.get_weather()
    assert(weather.wind_speed == 40)
    assert(weather.temperature_degrees == 50)
  end

  test "not found in cache" do
    Cache.clear()
    {:ok, weather} = ProviderCache.get_weather()
    assert(weather == nil)
  end

end
