defmodule ExstreamPlaylistTest do
  use ExUnit.Case

  @path "support/sample_1080_libx264_aac_30s_video.mkv"
  
  test "it should get header" do
    assert Exstream.Playlist.get_header() === "#EXTM3U\n"
  end

  test "it should get playlist type" do
    assert Exstream.Playlist.get_playlist_type === "#EXT-X-PLAYLIST-TYPE:VOD\n"
  end
  
  test "it should get target duration" do
    assert Exstream.Playlist.get_target_duration("30.89") === "#EXT-X-TARGETDURATION:30\n"
  end
  
  test "it should get version" do
    assert Exstream.Playlist.get_version === "#EXT-X-VERSION:4\n"
  end

  test "it should get media sequence" do
    assert Exstream.Playlist.get_media_sequence === "#EXT-X-MEDIA-SEQUENCE:0\n"
  end
  
  test "it should get track information" do
    assert Exstream.Playlist.get_track_information === "#EXTINF:08.0,\n/start\n"
  end

  test "it should get another track information" do
    assert Exstream.Playlist.get_another_track_information === "#EXTINF:08.0,\n/end\n"
  end

  test "it should get end list" do
    assert Exstream.Playlist.get_end_list === "#EXT-X-ENDLIST"
  end

  test "it should build" do
    assert Exstream.Playlist.build(@path) === "#EXTM3U\n#EXT-X-PLAYLIST-TYPE:VOD\n#EXT-X-TARGETDURATION:30\n#EXT-X-VERSION:4\n#EXT-X-MEDIA-SEQUENCE:0\n#EXTINF:08.0,\n/start\n#EXTINF:08.0,\n/end\n#EXT-X-ENDLIST"
  end
end