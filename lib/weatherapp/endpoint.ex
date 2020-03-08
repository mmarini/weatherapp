defmodule Weatherapp.Endpoint do
  @moduledoc """
  A Plug responsible for logging request info, parsing request body's as JSON,
  matching routes, and dispatching responses.
  """

  use Plug.Router

  # Log request information
  plug(Plug.Logger)

  # matches routes
  plug :match

  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)

  # dispath responses
  plug :dispatch

  get "/" do
    conn
    |> send_resp(200, "fetching weather info!")
  end

  match _ do
    conn
    |> send_resp(404, "oops... Nothing here :(")
  end

end
