defmodule Exstream.Duration do

  def parse(<<hour::binary-size(1), ":", minutes::binary-size(2), ":", seconds::binary>>) do
    "0#{ hour }:#{ minutes }:#{ seconds }"
  end

  def parse(<<hours::binary-size(2), ":", minutes::binary-size(2), ":", seconds::binary>>) do
    "#{ hours }:#{ minutes }:#{ seconds }"
  end

  def parse(<<"0:", seconds::binary>>) do
    "00:00:#{ seconds }"
  end

  def parse(<<minute::binary-size(1), ":", seconds::binary>>) do
    "00:0#{ minute }:#{ seconds }"
  end

  def parse(<<minutes::binary-size(2), ":", seconds::binary>>) do
    "00:#{ minutes }:#{ seconds }"
  end

  def parse(7, duration) do
    "0#{duration}"
  end

  def parse(8, duration) do
    duration
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
