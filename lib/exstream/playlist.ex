defmodule Exstream.Playlist do

  defstruct [:url, :duration]

  @type t :: %__MODULE__{url: String.t, duration: String.t}

  def get_step(duration, step, base_url) do
    "#EXTINF:#{ Exstream.get_one_tenth(duration) },\n#{ base_url }&segment=#{ Exstream.get_step(duration, step) }\n"
  end

  def parse_duration(7, duration) do
    "0#{ duration }"
  end

  def parse_duration(8, duration) do
    duration
  end

  def parse_duration(duration) do
    String.length(duration) |> parse_duration(duration)
  end

  def get_duration_second(duration) do
    { :ok, result } = parse_duration(duration) |> Time.from_iso8601()

    result.second
  end

  def get_duration_minute(duration) do
    { :ok, result } = parse_duration(duration) |> Time.from_iso8601()

    result.minute
  end

  def get_duration_hour(duration) do
    { :ok, result } = parse_duration(duration) |> Time.from_iso8601()

    result.hour
  end

  def build(path, base_url) do

    duration = Exstream.probe(path) |> Exstream.get_duration()

    "#EXTM3U\n" <>
    "#EXT-X-PLAYLIST-TYPE:VOD\n" <>
    "#EXT-X-TARGETDURATION:10\n" <>
    "#EXT-X-VERSION:4\n" <>
    "#EXT-X-MEDIA-SEQUENCE:0\n" <>
    get_step(duration, 0, base_url) <>
    get_step(duration, 1, base_url) <>
    get_step(duration, 2, base_url) <>
    get_step(duration, 3, base_url) <>
    get_step(duration, 4, base_url) <>
    get_step(duration, 5, base_url) <>
    get_step(duration, 6, base_url) <>
    get_step(duration, 7, base_url) <>
    get_step(duration, 8, base_url) <>
    get_step(duration, 9, base_url) <>
    "#EXT-X-ENDLIST"
  end
end
