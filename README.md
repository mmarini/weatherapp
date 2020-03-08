# Weatherapp

The weatherapp will report back a the temperature and wind speed in a json format

## Installation

The weather app is written in elixir. It requires both elixir and erlang to run.

The versions are:

- elixir: v1.9.1
- erlang: 22.0.7

There is a `.tool-versions` file that can be used with the `asdf` package manager. To install and use on macOS

```bash
brew install asdf
asdf plugin add erlang
asdf install erlang 22.0.7
asdf plugin add elixir
asdf install elixir 1.9.1
```

To run the application

```bash
git clone https://github.com/mmarini/weatherapp.git
cd weatherapp
mix deps.get
mix run --no-halt
```

## Design decisions

### Service Providers

Each weather provider is located as a separate file in the lib/weatherapp/service/providers directory. This includes:

- reading from the cache
- querying weather_strack
- querying open weather map

Each provider implements a behaviour, Weatherapp.Service.WeatherProvider, which defines a method called get_weather which returns a tuple of {:ok, value}. The value can be nil, or a record of type Weatherapp.Records.Weather.

The module Weatherapp.Service.WeatherService will get the weather from each service, so long as it returns an {:ok, nil} tuple. At the end, it will cache the result, but only if it didn't come from the cache in the first place.

## Tests

To run the unit tests, execute

```bash
mix test
```

The results of Weather Stack and Open Weather Map were captured using the ex_vcr package. The results of those are in the `fixture/vcr_cassettes`

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/weatherapp](https://hexdocs.pm/weatherapp).

