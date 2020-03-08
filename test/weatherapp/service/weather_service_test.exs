defmodule Weatherapp.Service.WeatherServiceTest do
  @moduledoc """
    Tests for the weatherstack service
  """

  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Weatherapp.Cache.Cache
  alias Weatherapp.Service.WeatherService

  setup_all do
    HTTPoison.start
  end

  test "get from cache" do
    record = %Weatherapp.Records.Weather{temperature_degrees: 50, wind_speed: 50}

    Cache.start()
    Cache.insert(record)
    assert(WeatherService.get_weather() == {:ok, record})
  end

  test "get from weather stack" do
    use_cassette "weather_stack/success" do
      record = %Weatherapp.Records.Weather{temperature_degrees: 20, wind_speed: 13}

      Cache.start()
      assert(WeatherService.get_weather() == {:ok, record})
    end
  end

  test "get from open weather map" do
    use_cassette "combination/weather_stack_failed_open_weather_success" do
      record = %Weatherapp.Records.Weather{temperature_degrees: 19.16, wind_speed: 8.2}

      Cache.start()
      assert(WeatherService.get_weather() == {:ok, record})
    end
  end
end
