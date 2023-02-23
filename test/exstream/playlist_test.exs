defmodule Exstream.Playlist.Test do
  use ExUnit.Case

  @video "priv/video.mkv"
  
  test "it should get header" do
    assert Exstream.Playlist.get_header() === "#EXTM3U\n"
  end

  test "it should get type" do
    assert Exstream.Playlist.get_type === "#EXT-X-PLAYLIST-TYPE:VOD\n"
  end
  
  test "it should get duration" do
    assert Exstream.Playlist.get_duration() === "#EXT-X-TARGETDURATION:10\n"
  end
  
  test "it should get version" do
    assert Exstream.Playlist.get_version === "#EXT-X-VERSION:4\n"
  end

  test "it should get sequence" do
    assert Exstream.Playlist.get_sequence === "#EXT-X-MEDIA-SEQUENCE:0\n"
  end

  test "it should get end" do
    assert Exstream.Playlist.get_end === "#EXT-X-ENDLIST"
  end

  test "it should build" do
    assert Exstream.Playlist.build(@video, "/some/base/url?token=some-token") === "#EXTM3U\n#EXT-X-PLAYLIST-TYPE:VOD\n#EXT-X-TARGETDURATION:10\n#EXT-X-VERSION:4\n#EXT-X-MEDIA-SEQUENCE:0\n#EXTINF:3,\n/some/base/url?token=some-token&segment=0\n#EXTINF:3,\n/some/base/url?token=some-token&segment=3\n#EXTINF:3,\n/some/base/url?token=some-token&segment=6\n#EXTINF:3,\n/some/base/url?token=some-token&segment=9\n#EXTINF:3,\n/some/base/url?token=some-token&segment=12\n#EXTINF:3,\n/some/base/url?token=some-token&segment=15\n#EXTINF:3,\n/some/base/url?token=some-token&segment=18\n#EXTINF:3,\n/some/base/url?token=some-token&segment=21\n#EXTINF:3,\n/some/base/url?token=some-token&segment=24\n#EXTINF:3,\n/some/base/url?token=some-token&segment=27\n#EXT-X-ENDLIST"
  end

  test "it should parse invalid duration" do
    assert Exstream.Playlist.parse_duration("1:40:30") === "01:40:30"
  end

  test "it should parse duration" do
    assert Exstream.Playlist.parse_duration("01:40:30") === "01:40:30"
  end

  test "it should get duration second" do
    assert Exstream.Playlist.get_duration_second("1:40:30") === 30
  end

  test "it should get duration minute" do
    assert Exstream.Playlist.get_duration_minute("1:40:30") === 40
  end

  test "it should get duration hour" do
    assert Exstream.Playlist.get_duration_hour("1:40:30") === 1
  end
end