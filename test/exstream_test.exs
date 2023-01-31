defmodule ExstreamTest do
  use ExUnit.Case
  use Plug.Test

  @manifest "support/out.m3u8"
  @segment "support/out.ts"
  
  test "it should get manifest" do
    conn = conn(:get, "/")
           |> Exstream.get_manifest(@manifest)

    assert conn.status === 200
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "vnd.apple.mpegURL"})
  end

  test "it should start" do

    conn = conn(:get, "/")
           |> put_req_header("range", "bytes=0-16351754")
           |> Exstream.get_video(@segment)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp2t"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-16351753/16351754"})
  end

  test "it should seek" do

    conn = conn(:get, "/")
           |> put_req_header("range", "bytes=124-16351754")
           |> Exstream.get_video(@segment)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp2t"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 124-16351753/16351754"})
  end
end