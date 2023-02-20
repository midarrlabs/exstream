defmodule ExstreamTest do
  use ExUnit.Case

  @video "test/fixtures/video.mkv"

  setup do
    [
      packets: Exstream.probe(@video) |> Exstream.get_packets(),
      keyframe_packets: Exstream.probe(@video) |> Exstream.get_keyframe_packets(),
      duration: Exstream.probe(@video) |> Exstream.get_duration()
    ]
  end

  @doc """
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
  """

  test "it should have packet", context do
    assert context[:packets]
           |> Enum.at(0) === %{"flags" => "K_", "pos" => "2563", "pts_time" => "0.054000"}
  end

  test "it should get closest packet to byte", context do
    assert context[:packets]
           |> Exstream.get_closest_packet_to_byte(24000) === %{"flags" => "__", "pos" => "26303", "pts_time" => "0.104000"}
  end

  @doc """
  [
    %{"flags" => "K_", "pos" => "2563", "pts_time" => "0.054000"},
    %{"flags" => "K_", "pos" => "421485", "pts_time" => "4.204000"},
    %{"flags" => "K_", "pos" => "2206473", "pts_time" => "8.371000"},
    %{"flags" => "K_", "pos" => "5582774", "pts_time" => "12.538000"},
    %{"flags" => "K_", "pos" => "8561437", "pts_time" => "16.288000"},
    %{"flags" => "K_", "pos" => "12035419", "pts_time" => "20.154000"},
    %{"flags" => "K_", "pos" => "13203345", "pts_time" => "24.321000"},
    %{"flags" => "K_", "pos" => "14076737", "pts_time" => "27.454000"}
  ]
  """

  test "it should get keyframes", context do
    assert context[:keyframe_packets]
           |> Enum.at(2) === %{"flags" => "K_", "pos" => "2206473", "pts_time" => "8.371000"}
  end

  test "it should get closest keyframe packet to byte", context do
    assert context[:keyframe_packets]
           |> Exstream.get_closest_packet_to_byte(6400000) === %{"flags" => "K_", "pos" => "5582774", "pts_time" => "12.538000"}
  end

  test "it should get total duration", context do
    assert context[:duration] === 30
  end

  test "it should get 1/10 duration", context do
    assert context[:duration]
           |> Exstream.get_one_tenth() === 3
  end

  test "it should get duration steps", context do
    assert context[:duration]
           |> Exstream.get_steps() === [0, 3, 6, 9, 12, 15, 18, 21, 24, 27, 30]
  end

  test "it should get step", context do
    assert context[:duration]
           |> Exstream.get_step(1) === 3
  end

  test "it should segment" do
    assert is_binary Exstream.segment(@video, 3)
  end
end
