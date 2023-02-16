defmodule ExstreamPlaylist do

  def get_header() do
    "#EXTM3U\n"
  end

  def get_playlist_type() do
    "#EXT-X-PLAYLIST-TYPE:VOD\n"
  end
end
