defmodule Weatherapp.Service.Providers.Cache do
  @moduledoc """
    Gets the weather information from the cache
  """

  @behaviour Weatherapp.Service.WeatherProvider

  require Logger

  alias Weatherapp.Cache.Cache

  @impl Weatherapp.Service.WeatherProvider
  def get_weather do
    Logger.info("[Cache] Getting weather information")
    {:ok, Cache.read()}
  end
end
