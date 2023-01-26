defmodule ExstreamTest do
  use ExUnit.Case
  use Plug.Test

  @path "support/sample_1080_libx264_aac_30s_video.mkv"

  [
    %{"flags" => "K_", "pos" => "2563", "pts_time" => "0.054000"},
    %{"flags" => "__", "pos" => "5300", "pts_time" => "0.071000"},
    %{"flags" => "__", "pos" => "6583", "pts_time" => "0.088000"},
    %{"flags" => "__", "pos" => "17447", "pts_time" => "0.121000"},
    %{"flags" => "__", "pos" => "26303", "pts_time" => "0.104000"},
    %{"flags" => "__", "pos" => "26911", "pts_time" => "0.138000"},
    %{"flags" => "__", "pos" => "31080", "pts_time" => "0.188000"},
    %{"flags" => "__", "pos" => "38352", "pts_time" => "0.154000"},
    %{"flags" => "__", "pos" => "44880", "pts_time" => "0.171000"},
    %{"flags" => "__", "pos" => "46588", "pts_time" => "0.221000"}
  ]

  test "it should get start" do
    assert Exstream.get_start(@path, 18447) === 0.121
  end

  test "it should get end 3" do
    assert Exstream.get_end(@path, 0.054) === 3
  end

  test "it should get end 9" do
    assert Exstream.get_end(@path, 6.054) === 9
  end

  test "it should get end 21" do
    assert Exstream.get_end(@path, 18.054) === 21
  end

  test "it should return video chunk name" do

    some_random_string = Exstream.random_string()

    assert Exstream.chunk(@path, 2818447, some_random_string) === "#{ some_random_string }.mp4"

    File.rm("#{ some_random_string }.mp4")
  end

  test "it should start" do

    conn = conn(:get, "/")
           |> Exstream.video(@path)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-16351753/16351754"})
  end

  test "it should seek" do

    conn = conn(:get, "/")
           |> put_req_header("range", "bytes=124-")
           |> Exstream.video(@path)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 124-16351753/16351754"})
  end

  test "it should Safari probe" do

    conn = conn(:get, "/")
           |> put_req_header("range", "bytes=0-1")
           |> Exstream.video(@path)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-1/16351754"})
  end
end