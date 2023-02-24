defmodule Exstream.Duration do

  def parse(7, duration) do
    "0#{duration}"
  end

  def parse(8, duration) do
    duration
  end

  def parse(duration) do
    String.length(duration) |> parse(duration)
  end

  def get_second(duration) do
    {:ok, result} = parse(duration) |> Time.from_iso8601()

    result.second
  end

  def get_minute(duration) do
    {:ok, result} = parse(duration) |> Time.from_iso8601()

    result.minute
  end

  def get_hour(duration) do
    {:ok, result} = parse(duration) |> Time.from_iso8601()

    result.hour
  end

  def get_seconds(duration) do
    get_second(duration) + get_minute(duration) * 60 +
      get_hour(duration) * 3600
  end
end
