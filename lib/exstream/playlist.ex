defmodule Exstream.Playlist do

  defstruct [:duration, :url]

  @type t :: %__MODULE__{duration: String.t, url: String.t}

  def get_step(duration, step, url) do
    "#EXTINF:#{ Exstream.get_one_tenth(duration) },\n#{ url }&segment=#{ Exstream.get_step(duration, step) }\n"
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

  def build(%Exstream.Playlist{duration: duration, url: url}) do

    parsed_duration = get_duration_second(duration)

    "#EXTM3U\n" <>
    "#EXT-X-PLAYLIST-TYPE:VOD\n" <>
    "#EXT-X-TARGETDURATION:10\n" <>
    "#EXT-X-VERSION:4\n" <>
    "#EXT-X-MEDIA-SEQUENCE:0\n" <>
    get_step(parsed_duration, 0, url) <>
    get_step(parsed_duration, 1, url) <>
    get_step(parsed_duration, 2, url) <>
    get_step(parsed_duration, 3, url) <>
    get_step(parsed_duration, 4, url) <>
    get_step(parsed_duration, 5, url) <>
    get_step(parsed_duration, 6, url) <>
    get_step(parsed_duration, 7, url) <>
    get_step(parsed_duration, 8, url) <>
    get_step(parsed_duration, 9, url) <>
    "#EXT-X-ENDLIST"
  end
end
