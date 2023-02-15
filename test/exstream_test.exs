defmodule ExstreamTest do
  use ExUnit.Case
  use Plug.Test

  @path "support/sample_1080_libx264_aac_30s_video.mkv"

  setup do
    [
      packets: Exstream.probe(@path) |> Exstream.get_packets(),
      keyframe_packets: Exstream.probe(@path) |> Exstream.get_keyframe_packets(),
      duration: Exstream.probe(@path) |> Exstream.get_duration()
    ]
  end

  test "it should range without headers" do
    conn =
      conn(:get, "/")
      |> Exstream.video(@path)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-16351753/16351754"})
  end

  test "it should range" do
    conn =
      conn(:get, "/")
      |> put_req_header("range", "bytes=0-")
      |> Exstream.video(@path)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-16351753/16351754"})
  end

  test "it should range seek" do
    conn =
      conn(:get, "/")
      |> put_req_header("range", "bytes=12345-")
      |> Exstream.video(@path)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 12345-16351753/16351754"})
  end

  test "it should range Safari probe" do
    conn =
      conn(:get, "/")
      |> put_req_header("range", "bytes=0-1")
      |> Exstream.video(@path)

    assert conn.status === 206
    assert conn.state === :file
    assert Enum.member?(conn.resp_headers, {"content-type", "video/mp4"})
    assert Enum.member?(conn.resp_headers, {"content-range", "bytes 0-1/16351754"})
  end

  @first_10_packets [
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

  test "it should have packet", context do
    assert context[:packets]
           |> Enum.at(0) === %{"flags" => "K_", "pos" => "2563", "pts_time" => "0.054000"}
  end

  test "it should get packet", context do
    assert context[:packets]
           |> Enum.at(0) === Enum.at(@first_10_packets, 0)
  end

  test "it should get closest packet to byte", context do
    assert context[:packets]
           |> Exstream.get_closest_packet_to_byte(24000) === Enum.at(@first_10_packets, 4)
  end

  @keyframes [
    %{"flags" => "K_", "pos" => "2563", "pts_time" => "0.054000"},
    %{"flags" => "K_", "pos" => "421485", "pts_time" => "4.204000"},
    %{"flags" => "K_", "pos" => "2206473", "pts_time" => "8.371000"},
    %{"flags" => "K_", "pos" => "5582774", "pts_time" => "12.538000"},
    %{"flags" => "K_", "pos" => "8561437", "pts_time" => "16.288000"},
    %{"flags" => "K_", "pos" => "12035419", "pts_time" => "20.154000"},
    %{"flags" => "K_", "pos" => "13203345", "pts_time" => "24.321000"},
    %{"flags" => "K_", "pos" => "14076737", "pts_time" => "27.454000"}
  ]

  test "it should get keyframes", context do
    assert context[:keyframe_packets] === @keyframes
  end

  test "it should get closest keyframe packet to byte", context do
    assert context[:keyframe_packets]
           |> Exstream.get_closest_packet_to_byte(6400000) === Enum.at(@keyframes, 3)
  end

  test "it should get total duration", context do
    assert context[:duration] === "30.021000"
  end
end
