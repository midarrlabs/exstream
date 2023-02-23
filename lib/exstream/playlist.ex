defmodule Exstream.Playlist do

  defstruct [:url, :duration]

  @type t :: %__MODULE__{url: String.t, duration: String.t}

  def get_header() do
    "#EXTM3U\n"
  end

  def get_type() do
    "#EXT-X-PLAYLIST-TYPE:VOD\n"
  end

  def get_duration() do
    "#EXT-X-TARGETDURATION:10\n"
  end

  def get_version() do
    "#EXT-X-VERSION:4\n"
  end

  def get_sequence() do
    "#EXT-X-MEDIA-SEQUENCE:0\n"
  end

  def get_step(duration, step, base_url) do
    "#EXTINF:#{ Exstream.get_one_tenth(duration) },\n#{ base_url }&segment=#{ Exstream.get_step(duration, step) }\n"
  end

  def get_end() do
    "#EXT-X-ENDLIST"
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

    get_header() <>
    get_type() <>
    get_duration() <>
    get_version() <>
    get_sequence() <>
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
    get_end()
  end
end
