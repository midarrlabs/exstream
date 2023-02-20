defmodule Exstream.Playlist do

  def get_header() do
    "#EXTM3U\n"
  end

  def get_playlist_type() do
    "#EXT-X-PLAYLIST-TYPE:VOD\n"
  end

  def get_target_duration(duration) do
    "#EXT-X-TARGETDURATION:#{ duration }\n"
  end

  def get_version() do
    "#EXT-X-VERSION:4\n"
  end

  def get_media_sequence() do
    "#EXT-X-MEDIA-SEQUENCE:0\n"
  end

  def get_step(duration, step) do
    "#EXTINF:#{ Exstream.get_one_tenth(duration) },\n/segments/#{ Exstream.get_step(duration, step) }\n"
  end

  def get_end_list() do
    "#EXT-X-ENDLIST"
  end

  def build(path) do

    duration = Exstream.probe(path) |> Exstream.get_duration()

    get_header() <>
    get_playlist_type() <>
    get_target_duration(duration) <>
    get_version() <>
    get_media_sequence() <>
    get_step(duration, 0) <>
    get_step(duration, 1) <>
    get_step(duration, 2) <>
    get_step(duration, 3) <>
    get_step(duration, 4) <>
    get_step(duration, 5) <>
    get_step(duration, 6) <>
    get_step(duration, 7) <>
    get_step(duration, 8) <>
    get_step(duration, 9) <>
    get_end_list()
  end
end
