defmodule ExstreamPlaylistTest do
  use ExUnit.Case
  
  test "it should have file header" do
    assert ExstreamPlaylist.header() === "#EXTM3U\n"
  end
end