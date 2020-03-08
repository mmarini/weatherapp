defmodule WeatherappTest do
  @moduledoc """
    test
  """

  use ExUnit.Case
  doctest Weatherapp

  test "greets the world" do
    assert Weatherapp.hello() == :world
  end
end
