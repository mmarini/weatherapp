defmodule Weatherapp.Service.WeatherstackTest do
  @moduledoc """
    Tests for the weatherstack service
  """

  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Weatherapp.Service.Weatherstack

  setup_all do
    HTTPoison.start
  end

  test "get successful request" do
    use_cassette "weatherstack/success" do
      {:ok, weather} = Weatherstack.get_weather()
      assert(weather.wind_speed == 13)
      assert(weather.temperature_degrees == 20)
    end
  end

  test "get invalid city" do
    use_cassette "weatherstack/failure" do
      {:ok, weather} = Weatherstack.get_weather()
      assert(weather == nil)
    end
  end

  test "get invalid request" do
    use_cassette "weatherstack/invalid_request" do
      {:ok, weather} = Weatherstack.get_weather()
      assert(weather == nil)
    end
  end

end
