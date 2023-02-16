defmodule ExstreamPlaylistTest do
  use ExUnit.Case
  
  test "it should get header" do
    assert Exstream.Playlist.get_header() === "#EXTM3U\n"
  end

  test "it should get playlist type" do
    assert Exstream.Playlist.get_playlist_type === "#EXT-X-PLAYLIST-TYPE:VOD\n"
  end
  
  test "it should get target duration" do
    assert Exstream.Playlist.get_target_duration === "#EXT-X-TARGETDURATION:16\n"
  end
  
  test "it should get version" do
    assert Exstream.Playlist.get_version === "#EXT-X-VERSION:4\n"
  end

  test "it should get media sequence" do
    assert Exstream.Playlist.get_media_sequence === "#EXT-X-MEDIA-SEQUENCE:0\n"
  end
end