defmodule ExstreamPlaylistTest do
  use ExUnit.Case
  
  test "it should get header" do
    assert ExstreamPlaylist.get_header() === "#EXTM3U\n"
  end
end