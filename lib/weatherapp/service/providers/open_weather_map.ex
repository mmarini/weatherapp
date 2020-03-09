defmodule Weatherapp.Service.Providers.OpenWeatherMap do
  @moduledoc """
    Gets the weather information at Open Weather Map
  """

  @behaviour Weatherapp.Service.WeatherProvider

  require Logger

  @impl Weatherapp.Service.WeatherProvider
  def get_weather do
    case request() do
      {:ok, response} ->
        {:ok, parse(response)}
      {:error, _} ->
        {:ok, nil}
    end
  end

  defp request do
    url = "http://api.openweathermap.org/data/2.5/weather"

    # ====== Query Params ======
    params = [
      {"appId", app_id()},
      {"q", "melbourne,AU"},
      {"units", "metric"}
    ]

    Logger.info("[OpenWeatherMap] Getting weather information")

    HTTPoison.start()
    case HTTPoison.get(url, [], params: params) do
      {:ok, response = %HTTPoison.Response{status_code: status_code, body: body}} ->
        Logger.info("[OpenWeatherMap] Response Status Code: #{status_code}")
        Logger.info("[OpenWeatherMap] Response Body: #{body}")

        {:ok, response}
      {:error, error = %HTTPoison.Error{reason: reason}} ->
        Logger.info("[OpenWeatherMap] Request failed: #{reason}")

        {:error, error}
    end
  end

  defp parse(%HTTPoison.Response{body: body}) do
    case Poison.decode(body) do
      {:ok, parsed_body} ->
        parse_body(parsed_body["main"], parsed_body["wind"])
      _ ->
        nil
    end
  end

  defp parse_body(nil, nil), do: nil
  defp parse_body(_main, nil), do: nil
  defp parse_body(nil, _wind), do: nil

  defp parse_body(main, wind) do
    %Weatherapp.Records.Weather{
      wind_speed: wind["speed"],
      temperature_degrees: main["temp"]
    }
  end

  defp app_id do
    Application.get_env(:weatherapp, :open_weather_map)
    |> Map.get(:appId)
  end
end
