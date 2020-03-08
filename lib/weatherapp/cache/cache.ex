defmodule Weatherapp.Cache.Cache do
  @moduledoc """
    Uses internal ETS tables for cache
  """

  require Logger

  alias Weatherapp.Cache.CacheRecord

  def start do
    initialize_table(exists?())
  end

  def insert(weather) do
    start()
    :ets.insert(:weather, {1, %CacheRecord{expiry_time: DateTime.add(DateTime.utc_now, 3, :second), record: weather}})
  end

  def read do
    start()
    read_record()
  end

  defp read_record do
    :ets.lookup(:weather, 1)
    |> Enum.map(fn({_key, value}) -> invalidate_record(value, DateTime.diff(value.expiry_time, DateTime.utc_now)) end)
    |> Enum.filter(& !is_nil(&1))
    |> Enum.at(0)
    |> parse_record
  end

  def clear do
    start()
    :ets.delete(:weather, 1)
  end

  defp invalidate_record(%CacheRecord{} = record, expired) when expired < 0 do
    :ets.delete(:weather, record)
    nil
  end

  defp invalidate_record(%CacheRecord{} = record, _expired), do: record

  defp parse_record(nil), do: nil
  defp parse_record(%CacheRecord{record: record}), do: record

  defp exists? do
    table_name = :weather
    table_list = :ets.all |> Enum.filter(fn(x) -> x == table_name end)
    Enum.count(table_list) > 0
  rescue
    _ -> false
  end

  defp initialize_table(true), do: :weather

  defp initialize_table(false) do
    Logger.info("Initializing table")
    :ets.new(:weather, [:set, :public, :named_table])
  end

end
