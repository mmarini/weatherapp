defmodule WeatherappTest do
  use ExUnit.Case
  doctest Weatherapp

  test "greets the world" do
    assert Weatherapp.hello() == :world
  end
end
