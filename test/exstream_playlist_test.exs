defmodule ExstreamPlaylistTest do
  use ExUnit.Case
  
  test "it should get header" do
    assert ExstreamPlaylist.get_header() === "#EXTM3U\n"
  end

  test "it should get playlist type" do
    assert ExstreamPlaylist.get_playlist_type === "#EXT-X-PLAYLIST-TYPE:VOD\n"
  end
  
  test "it should get target duration" do
    assert ExstreamPlaylist.get_target_duration === "#EXT-X-TARGETDURATION:16\n"
  end
end