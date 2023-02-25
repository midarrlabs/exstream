defmodule Exstream.Playlist.Test do
  use ExUnit.Case

  test "it should build 30 seconds" do
    assert Exstream.Playlist.build(%Exstream.Playlist{
             duration: "0:30",
             url: "/some/base/url?token=some-token"
           }) === File.read!("test/fixtures/playlist.m3u8")
  end
end
