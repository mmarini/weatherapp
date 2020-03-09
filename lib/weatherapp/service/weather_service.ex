defmodule Weatherapp.Service.WeatherService do
  @moduledoc """
    Gets the weather information from the first service it hits
  """

  alias Weatherapp.Service.WeatherProvider
  alias Weatherapp.Service.Providers.{Cache, OpenWeatherMap, WeatherStack}

  @spec get_weather :: {:ok, nil | Weatherapp.Records.Weather.t()}
  def get_weather do
    get_weather_from_providers()
  end

  defp get_weather_from_providers do
    {:ok, nil, nil}
    |> get_weather_from(Cache)
    |> get_weather_from(WeatherStack)
    |> get_weather_from(OpenWeatherMap)
    |> cache_result()
  end

  defp get_weather_from({:ok, _, nil}, module) do
    {:ok, result} = WeatherProvider.get_weather(module)
    {:ok, module, result}
  end

  defp get_weather_from(weather_record, _module) do
    weather_record
  end

  defp cache_result({:ok, _module, nil}), do: {:ok, nil}
  defp cache_result({:ok, Cache, result}), do: {:ok, result}
  defp cache_result({:ok, _, result}) do
    Weatherapp.Cache.Cache.insert(result)
    {:ok, result}
  end

  def format_as_json({:ok, nil}) do
    Poison.encode!(%{error: "Weather services currently not reporting"})
  end

  def format_as_json({:ok, result}) do
    Poison.encode!(result)
  end
end
