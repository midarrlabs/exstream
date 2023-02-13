defmodule ExstreamTest do
  use ExUnit.Case
  use Plug.Test

  @path "support/sample_1080_libx264_aac_30s_video.mkv"

  test "it should handle without headers" do

    conn = conn(:get, "/")
           |> Exstream.video(@path)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-16351753/16351754"})
  end

  test "it should handle default browser request" do

    conn = conn(:get, "/")
           |> put_req_header("range", "bytes=0-")
           |> Exstream.video(@path)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-16351753/16351754"})
  end

  test "it should handle seek" do

    conn = conn(:get, "/")
           |> put_req_header("range", "bytes=12345-")
           |> Exstream.video(@path)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 12345-16351753/16351754"})
  end

  test "it should handle Safari probe" do

    conn = conn(:get, "/")
           |> put_req_header("range", "bytes=0-1")
           |> Exstream.video(@path)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-1/16351754"})
  end

  test "it should have packet" do
    assert Exstream.probe(@path)
           |> Enum.at(0) === %{"flags" => "K_", "pos" => "2563", "pts_time" => "0.054000"}
  end
end