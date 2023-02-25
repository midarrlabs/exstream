defmodule Exstream.Range.Test do
  use ExUnit.Case
  use Plug.Test

  @video "priv/video.mkv"

  test "it should range without headers" do
    conn = Exstream.Range.stream(%Exstream.Range{conn: conn(:get, "/"), path: @video})

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-1794889/1794890"})
  end

  test "it should range" do
    conn =
      Exstream.Range.stream(%Exstream.Range{
        conn: conn(:get, "/") |> put_req_header("range", "bytes=0-"),
        path: @video
      })

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-1794889/1794890"})
  end

  test "it should range seek" do
    conn =
      Exstream.Range.stream(%Exstream.Range{
        conn: conn(:get, "/") |> put_req_header("range", "bytes=12345-"),
        path: @video
      })

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 12345-1794889/1794890"})
  end

  test "it should range Safari probe" do
    conn =
      Exstream.Range.stream(%Exstream.Range{
        conn: conn(:get, "/") |> put_req_header("range", "bytes=0-1"),
        path: @video
      })

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-1/1794890"})
  end
end
