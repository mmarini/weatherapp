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

  describe "cache" do
    test "returns from cache" do
      record = %Weatherapp.Records.Weather{temperature_degrees: 50, wind_speed: 50}

      Cache.start()
      Cache.clear()
      Cache.insert(record)
      assert(WeatherService.get_weather() == {:ok, record})
    end
  end

  describe "weather stack" do
    test "returns from weather stack" do
      use_cassette "weather_stack/success" do
        record = %Weatherapp.Records.Weather{temperature_degrees: 20, wind_speed: 13}

        Cache.start()
        Cache.clear()
        assert(WeatherService.get_weather() == {:ok, record})
      end
    end

    test "stores result in cache" do
      use_cassette "weather_stack/success" do
        record = %Weatherapp.Records.Weather{temperature_degrees: 20, wind_speed: 13}

        Cache.start()
        Cache.clear()
        assert(WeatherService.get_weather() == {:ok, record})
        assert(Weatherapp.Service.Providers.Cache.get_weather() == {:ok, record})
      end
    end

  end

  describe "open weather map" do
    test "returns from open weather map" do
      use_cassette "combination/weather_stack_failed_open_weather_success" do
        record = %Weatherapp.Records.Weather{temperature_degrees: 19.16, wind_speed: 8.2}

        Cache.start()
        Cache.clear()
        assert(WeatherService.get_weather() == {:ok, record})
      end
    end

    test "stores result in cache" do
      use_cassette "combination/weather_stack_failed_open_weather_success" do
        record = %Weatherapp.Records.Weather{temperature_degrees: 19.16, wind_speed: 8.2}

        Cache.start()
        Cache.clear()
        assert(WeatherService.get_weather() == {:ok, record})
        assert(Weatherapp.Service.Providers.Cache.get_weather() == {:ok, record})
      end
    end
  end

  describe "format_as_json" do
    test "formats as json when there is a record" do
      record = %Weatherapp.Records.Weather{temperature_degrees: 19.16, wind_speed: 8.2}
      assert(WeatherService.format_as_json({:ok, record}) == "{\"wind_speed\":8.2,\"temperature_degrees\":19.16}")
    end

    test "formats and error message as json when there is no record" do
      assert(WeatherService.format_as_json({:ok, nil}) == "{\"error\":\"Weather services currently not reporting\"}")
    end
  end
end
