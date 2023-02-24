defmodule Exstream.Duration do

  def parse_duration(7, duration) do
    "0#{duration}"
  end

  def parse_duration(8, duration) do
    duration
  end

  def parse_duration(duration) do
    String.length(duration) |> parse_duration(duration)
  end

  def get_duration_second(duration) do
    {:ok, result} = parse_duration(duration) |> Time.from_iso8601()

    result.second
  end

  def get_duration_minute(duration) do
    {:ok, result} = parse_duration(duration) |> Time.from_iso8601()

    result.minute
  end

  def get_duration_hour(duration) do
    {:ok, result} = parse_duration(duration) |> Time.from_iso8601()

    result.hour
  end

  def get_seconds(duration) do
    get_duration_second(duration) + get_duration_minute(duration) * 60 +
      get_duration_hour(duration) * 3600
  end
end
