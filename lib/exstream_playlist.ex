defmodule ExstreamPlaylist do

  def get_header() do
    "#EXTM3U\n"
  end

  def get_playlist_type() do
    "#EXT-X-PLAYLIST-TYPE:VOD\n"
  end

  def get_target_duration() do
    "#EXT-X-TARGETDURATION:16\n"
  end
end
