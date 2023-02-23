defmodule ExstreamPlaylistTest do
  use ExUnit.Case

  @video "priv/video.mkv"
  
  test "it should get header" do
    assert Exstream.Playlist.get_header() === "#EXTM3U\n"
  end

  test "it should get playlist type" do
    assert Exstream.Playlist.get_playlist_type === "#EXT-X-PLAYLIST-TYPE:VOD\n"
  end
  
  test "it should get target duration" do
    assert Exstream.Playlist.get_target_duration(30) === "#EXT-X-TARGETDURATION:30\n"
  end
  
  test "it should get version" do
    assert Exstream.Playlist.get_version === "#EXT-X-VERSION:4\n"
  end

  test "it should get media sequence" do
    assert Exstream.Playlist.get_media_sequence === "#EXT-X-MEDIA-SEQUENCE:0\n"
  end

  test "it should get end list" do
    assert Exstream.Playlist.get_end_list === "#EXT-X-ENDLIST"
  end

  test "it should build" do
    assert Exstream.Playlist.build(@video, "/some/base/url?token=some-token") === "#EXTM3U\n#EXT-X-PLAYLIST-TYPE:VOD\n#EXT-X-TARGETDURATION:30\n#EXT-X-VERSION:4\n#EXT-X-MEDIA-SEQUENCE:0\n#EXTINF:3,\n/some/base/url?token=some-token&segment=0\n#EXTINF:3,\n/some/base/url?token=some-token&segment=3\n#EXTINF:3,\n/some/base/url?token=some-token&segment=6\n#EXTINF:3,\n/some/base/url?token=some-token&segment=9\n#EXTINF:3,\n/some/base/url?token=some-token&segment=12\n#EXTINF:3,\n/some/base/url?token=some-token&segment=15\n#EXTINF:3,\n/some/base/url?token=some-token&segment=18\n#EXTINF:3,\n/some/base/url?token=some-token&segment=21\n#EXTINF:3,\n/some/base/url?token=some-token&segment=24\n#EXTINF:3,\n/some/base/url?token=some-token&segment=27\n#EXT-X-ENDLIST"
  end
end