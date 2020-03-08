defmodule Weatherapp.Service.WeatherStackTest do
  @moduledoc """
    Tests for the weatherstack service
  """

  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Weatherapp.Service.WeatherStack

  setup_all do
    HTTPoison.start
  end

  test "get successful request" do
    use_cassette "weather_stack/success" do
      {:ok, weather} = WeatherStack.get_weather()
      assert(weather.wind_speed == 13)
      assert(weather.temperature_degrees == 20)
    end
  end

  test "get invalid city" do
    use_cassette "weather_stack/failure" do
      {:ok, weather} = WeatherStack.get_weather()
      assert(weather == nil)
    end
  end

  test "get invalid request" do
    use_cassette "weather_stack/invalid_request" do
      {:ok, weather} = WeatherStack.get_weather()
      assert(weather == nil)
    end
  end
end
