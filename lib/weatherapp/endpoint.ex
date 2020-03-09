defmodule Weatherapp.Endpoint do
  @moduledoc """
  A Plug responsible for logging request info, parsing request body's as JSON,
  matching routes, and dispatching responses.
  """

  alias Weatherapp.Service.WeatherService

  use Plug.Router

  # Log request information
  plug(Plug.Logger)

  # matches routes
  plug :match

  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)

  # dispath responses
  plug :dispatch

  get "/v1/weather" do

    result = WeatherService.get_weather()
      |> WeatherService.format_as_json()

    conn
    |> send_resp(200, result)
  end

  match _ do
    conn
    |> send_resp(404, "oops... Nothing here :(")
  end

end
