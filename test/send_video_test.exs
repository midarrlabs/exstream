defmodule SendVideoTest do
  use ExUnit.Case
  use Plug.Test

  @sample "test/fixtures/sample_1080_libx264_aac_30s_video.mkv"

  test "it should start" do

    conn = conn(:get, "/")
           |> Exstream.SendVideo.call(Exstream.SendVideo.init(@sample))

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-16351753/16351754"})
  end

  test "it should seek" do

    conn = conn(:get, "/")
           |> put_req_header("range", "bytes=124-")
           |> Exstream.SendVideo.call(Exstream.SendVideo.init(@sample))

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 124-16351753/16351754"})
  end
  
  test "it should Safari probe" do

    conn = conn(:get, "/")
           |> put_req_header("range", "bytes=0-1")
           |> Exstream.SendVideo.call(Exstream.SendVideo.init(@sample))

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-1/16351754"})
  end
end