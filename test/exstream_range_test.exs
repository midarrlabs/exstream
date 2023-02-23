defmodule ExstreamRangeTest do
  use ExUnit.Case
  use Plug.Test

  @video "priv/video.mkv"

  test "it should range without headers" do
    conn =
      conn(:get, "/")
      |> Exstream.Range.get_video(@video)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-16351753/16351754"})
  end

  test "it should range" do
    conn =
      conn(:get, "/")
      |> put_req_header("range", "bytes=0-")
      |> Exstream.Range.get_video(@video)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-16351753/16351754"})
  end

  test "it should range seek" do
    conn =
      conn(:get, "/")
      |> put_req_header("range", "bytes=12345-")
      |> Exstream.Range.get_video(@video)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 12345-16351753/16351754"})
  end

  test "it should range Safari probe" do
    conn =
      conn(:get, "/")
      |> put_req_header("range", "bytes=0-1")
      |> Exstream.Range.get_video(@video)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-1/16351754"})
  end
end
