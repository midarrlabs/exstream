defmodule ExstreamTest do
  use ExUnit.Case

  @sample "test/fixtures/sample_1080_libx264_aac_30s_video.mkv"

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

  setup do
    [
      packets: Exstream.probe(@sample) |> Exstream.get_packets(),
      duration: Exstream.probe(@sample) |> Exstream.get_duration()
    ]
  end

  test "it should get timestamp" do
    assert Exstream.get_start_timestamp_for_path(@sample, 18447) === 0.121
  end

  test "it should get duration", context do
    assert context[:duration] === 30.021
  end
  
  test "it should get duration steps", context do
    assert context[:duration]
           |> Exstream.get_steps() === [0, 3, 6, 9, 12, 15, 18, 21, 24, 27, 30]
  end

  test "it should get timestamp step 3", context do
    assert context[:duration]
           |> Exstream.get_steps()
           |> Exstream.get_step_for_timestamp(0.054) === 3
  end

  test "it should get timestamp step 9", context do
    assert context[:duration]
           |> Exstream.get_steps()
           |> Exstream.get_step_for_timestamp(6.054) === 9
  end

  test "it should get timestamp step 21", context do
    assert context[:duration]
           |> Exstream.get_steps()
           |> Exstream.get_step_for_timestamp(18.054) === 21
  end
end