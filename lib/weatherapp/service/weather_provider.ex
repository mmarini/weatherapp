defmodule Weatherapp.Service.WeatherProvider do
  @moduledoc """
    Defines behaviour for when we need to read from a weather provider
  """

  @callback get_weather :: {:ok, nil | Weatherapp.Records.Weather.t()}

  def get_weather(implementation) do
    implementation.get_weather()
  end

end
