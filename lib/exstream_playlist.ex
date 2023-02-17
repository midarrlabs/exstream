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

  def get_track_information() do
    "#EXTINF:08.0,\n/start\n"
  end

  def get_another_track_information() do
    "#EXTINF:08.0,\n/end\n"
  end

  def get_end_list() do
    "#EXT-X-ENDLIST"
  end

  def build(duration) do
    get_header() <>
    get_playlist_type() <>
    get_target_duration(duration) <>
    get_version() <>
    get_media_sequence() <>
    get_track_information() <>
    get_another_track_information() <>
    get_end_list()
  end
end