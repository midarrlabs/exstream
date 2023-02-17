defmodule Exstream.Playlist do

  def get_header() do
    "#EXTM3U\n"
  end

  def get_playlist_type() do
    "#EXT-X-PLAYLIST-TYPE:VOD\n"
  end

  def get_target_duration() do
    "#EXT-X-TARGETDURATION:16\n"
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
end
