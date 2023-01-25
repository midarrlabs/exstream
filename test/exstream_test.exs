defmodule ExstreamTest do
  use ExUnit.Case

  @sample "test/fixtures/sample_1080_libx264_aac_30s_video.mkv"

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

  setup do
    [
      packets: Exstream.probe(@sample) |> Exstream.get_packets(),
      duration: Exstream.probe(@sample) |> Exstream.get_duration()
    ]
  end

  test "it should have packet", context do
    assert context[:packets]
           |> Enum.member?(%{"flags" => "K_", "pos" => "2563", "pts_time" => "0.054000"})
  end

  test "it should get closest packet to byte", context do
    assert context[:packets]
           |> Exstream.get_closest_packet_to_byte(24000) === %{"flags" => "__", "pos" => "26303", "pts_time" => "0.104000"}
  end

  test "it should get timestamp", context do
    assert context[:packets]
           |> Enum.at(0)
           |> Exstream.get_timestamp() === 0.054
  end

  test "it should get duration", context do
    assert context[:duration] === 30.021
  end
end