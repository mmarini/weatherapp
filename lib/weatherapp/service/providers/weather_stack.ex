defmodule Weatherapp.Service.Providers.WeatherStack do
  @moduledoc """
    Calls the get /weather endpoint at weatherstack
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
    url = "http://api.weatherstack.com/current"

    # ====== Query Params ======
    params = [
      {"access_key", access_key()},
      {"query", "Melbourne"},
    ]

    Logger.info("[WeatherStack] Getting weather information from WeatherStack")

    HTTPoison.start()
    case HTTPoison.get(url, [], params: params) do
      {:ok, response = %HTTPoison.Response{status_code: status_code, body: body}} ->
        Logger.info("[WeatherStack] Response Status Code: #{status_code}")
        Logger.info("[WeatherStack] Response Body: #{body}")

        {:ok, response}
      {:error, error = %HTTPoison.Error{reason: reason}} ->
        Logger.info("[WeatherStack] Request failed: #{reason}")

        {:error, error}
    end
  end

  defp parse(%HTTPoison.Response{body: body}) do
    case Poison.decode(body) do
      {:ok, parsed_body} ->
        parse_body(parsed_body["current"])
      _ ->
        nil
    end
  end

  defp parse_body(nil), do: nil

  defp parse_body(parsed_body) do
    %Weatherapp.Records.Weather{
      wind_speed: parsed_body["wind_speed"],
      temperature_degrees: parsed_body["temperature"]
    }
  end

  defp access_key do
    Application.get_env(:weatherapp, :weather_stack)
    |> Map.get(:access_key)
  end
end
