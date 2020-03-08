defmodule Weatherapp.Service.WeatherStack do
  @moduledoc """
    Calls the get /weather endpoint at weatherstack
  """

  require Logger

  @spec get_weather :: {:ok, nil | Weatherapp.Records.Weather.t()}
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

    # ====== Headers ======
    headers = []

    # ====== Query Params ======
    params = [
      {"access_key", "7061fa1a579a309e3d3f0cd889270def"},
      {"query", "Melbourne"},
    ]

    Logger.info("Getting weather information from WeatherStack")

    HTTPoison.start()
    case HTTPoison.get(url, headers, params: params) do
      {:ok, response = %HTTPoison.Response{status_code: status_code, body: body}} ->
        Logger.info("Response Status Code: #{status_code}")
        Logger.info("Response Body: #{body}")

        {:ok, response}
      {:error, error = %HTTPoison.Error{reason: reason}} ->
        Logger.info("Request failed: #{reason}")

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
end
