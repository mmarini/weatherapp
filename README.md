# Weatherapp

The weatherapp will report back the temperature and wind speed in a json format.

## Installation

The weather app is written in elixir. It requires both elixir and erlang to run.

The versions are:

- elixir: v1.9.1
- erlang: v22.0.7

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
mix compile
mix run --no-halt
```

The application is listening on port 8080. To test

```bash
curl http://localhost:8080/v1/weather?city=melbourne
```

Note: The parameter is being ignored as the requirements did say that Melbourne could be hard coded. Using

```bash
curl http://localhost:8080/v1/weather
```

will also work

The result is dependant on the service, but you should see the following json as a result

```json
{"wind_speed":24,"temperature_degrees":20}
```

When looking at the console of the application, you should see the following logging

```bash
✓ 09/03/2020  3:13:12 pm % mix run --no-halt
Compiling 11 files (.ex)
Generated weatherapp app

15:13:22.249 [info]  Initializing table

15:13:31.705 [info]  GET /v1/weather

15:13:31.711 [info]  [Cache] Getting weather information

15:13:31.711 [info]  [WeatherStack] Getting weather information from WeatherStack

15:13:32.730 [info]  [WeatherStack] Response Status Code: 200

15:13:32.730 [info]  [WeatherStack] Response Body: {"request":{"type":"City","query":"Melbourne, Australia","language":"en","unit":"m"},"location":{"name":"Melbourne","country":"Australia","region":"Victoria","lat":"-37.817","lon":"144.967","timezone_id":"Australia\/Melbourne","localtime":"2020-03-09 14:58","localtime_epoch":1583765880,"utc_offset":"11.0"},"current":{"observation_time":"03:58 AM","temperature":20,"weather_code":116,"weather_icons":["https:\/\/assets.weatherstack.com\/images\/wsymbols01_png_64\/wsymbol_0002_sunny_intervals.png"],"weather_descriptions":["Partly cloudy"],"wind_speed":24,"wind_degree":170,"wind_dir":"S","pressure":1022,"precip":0,"humidity":49,"cloudcover":75,"feelslike":20,"uv_index":9,"visibility":10,"is_day":"yes"}}

15:13:32.752 [info]  Sent 200 in 1046ms
```

The item in the bracket is the name of the service provider. So in the above, it checked the Cache first, and then checked WeatherStack.

Subsequent calls should return from the cache

```bash
15:13:34.281 [info]  GET /v1/weather

15:13:34.281 [info]  [Cache] Getting weather information

15:13:34.281 [info]  Sent 200 in 102µs

15:13:34.974 [info]  GET /v1/weather

15:13:34.974 [info]  [Cache] Getting weather information

15:13:34.974 [info]  Sent 200 in 114µs

15:13:35.495 [info]  GET /v1/weather

15:13:35.495 [info]  [Cache] Getting weather information

15:13:35.495 [info]  Sent 200 in 88µs
```

The cache timeout is set to 3 seconds, but can be changed to a longer period in the `config/config.exs` file, in the value of `timeout_seconds`.

## Design decisions

### Service Providers

Each weather provider is located as a separate file in the lib/weatherapp/service/providers directory. This includes:

- reading from the cache
- querying weather strack
- querying open weather map

Each provider implements a behaviour, Weatherapp.Service.WeatherProvider, which defines a method called get_weather which returns a tuple of {:ok, value}. The value can be nil, or a record of type Weatherapp.Records.Weather.

The module Weatherapp.Service.WeatherService will get the weather from each service, so long as it returns an {:ok, nil} tuple. At the end, it will cache the result, but only if it didn't come from the cache in the first place.

The function `Weatherapp.Service.WeatherService.get_weather_from_providers` is the main method that asks each of the providers to provide the result. This is done in a pipeline way. Even though each of the items are called, they will only execute for that service if an {:ok, nil} tuple. The function, get_weather_from, uses pattern matching in the parameter list to ensure that the correct version of the function is called.

It might be a little wierd to review the code and see that there isn't an if statement (or loop) anywhere to be found. However pattern matching in this case handles that for us.

To extend to a new weather provider, a developer would have to:

- add a provider under `lib/weatherapp/service/providers`
- ensure that provider implements the behaviour of `weather_provider`
- add a call to `get_weather_from(MODULE_NAME)` in the pipeline in `Weatherapp.Service.WeatherService.get_weather_from_providers`
- write unit tests

### Cache

Erlang has a nifty part of it called ETS, Erlang Term Storage. It allows us to store records, handy for caching, without having to use a third party service like Redis, or a singleton strategy like we would use in an object oriented solution.

I wrote the cache as it's own module, in lib/weatherapp/cache/cache. I could have used a library, eg cachex, but decided to write my own to show that internally I was using ETS tables.

Doing this again, I would look at a library, or if it was an item that needed to be shared, potentially something like redis.

## Things I'd do differently

### Use a third party cache

I'd definately use a third party solution here. Writing a cache, especially one that is designed to be shared by many processes would be a management headache if writing and maintaining ourselves.

## Tests

To run the unit tests, execute

```bash
mix test
```

The results of Weather Stack and Open Weather Map were captured using the ex_vcr package. The results of those are in the `fixture/vcr_cassettes`
