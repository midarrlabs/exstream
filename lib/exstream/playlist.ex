defmodule Exstream.Playlist do
  defstruct [:duration, :url]

  @type t :: %__MODULE__{duration: String.t(), url: String.t()}

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

  def get_extinf(duration, url) do
    steps = floor(get_seconds(duration) / 10)

    Enum.map_join(1..steps, fn step ->
      "#EXTINF:10,\n#{url}&start=#{step * 10 - 10}&end=#{step * 10}\n"
    end)
  end

  def build(%Exstream.Playlist{duration: duration, url: url}) do
    "#EXTM3U\n" <>
      "#EXT-X-PLAYLIST-TYPE:VOD\n" <>
      "#EXT-X-TARGETDURATION:10\n" <>
      "#EXT-X-VERSION:4\n" <>
      "#EXT-X-MEDIA-SEQUENCE:0\n" <>
      get_extinf(duration, url) <>
      "#EXT-X-ENDLIST"
  end
end
