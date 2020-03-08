defmodule Weatherapp.Records.Weather do

  @moduledoc """
  Defines the weather structure we return
  """

  @derive [Poison.Encoder]
  defstruct wind_speed: nil,
            temperature_degrees: nil

end
