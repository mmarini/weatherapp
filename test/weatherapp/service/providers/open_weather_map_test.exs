defmodule Weatherapp.Service.Providers.OpenWeatherMapTest do
  @moduledoc """
    Tests for the Open Weather Map service
  """

  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Weatherapp.Service.Providers.OpenWeatherMap

  setup_all do
    HTTPoison.start
  end

  test "get successful request" do
    use_cassette "open_weather_map/success" do
      {:ok, weather} = OpenWeatherMap.get_weather()
      assert(weather.wind_speed == 4.6)
      assert(weather.temperature_degrees == 20.97)
    end
  end

  test "get invalid city" do
    use_cassette "open_weather_map/failure" do
      {:ok, weather} = OpenWeatherMap.get_weather()
      assert(weather == nil)
    end
  end

  test "get invalid request" do
    use_cassette "open_weather_map/invalid_request" do
      {:ok, weather} = OpenWeatherMap.get_weather()
      assert(weather == nil)
    end
  end

end
