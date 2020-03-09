# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# third-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :drl, key: :value
#

config :weatherapp,
  port: 8080,
  weather_stack: %{
    access_key: "7061fa1a579a309e3d3f0cd889270def"
  },
  open_weather_map: %{
    appId: "a7fbbdc4bf260fee1ca701b555778060"
  },
  cache: %{
    timeout_seconds: 3
  }

# and access this configuration in your application as:
#
#     Application.get_env(:drl, :key)
#
# You can also configure a third-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
import_config "#{Mix.env()}.exs"
