defmodule Weatherapp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias Weatherapp.Cache.Cache

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do

    import Supervisor.Spec, warn: false

    Cache.start()

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Weatherapp.Endpoint,
        options: [port: Application.get_env(:weatherapp, :port, 8080)]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Weatherapp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
