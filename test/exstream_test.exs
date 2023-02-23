defmodule ExstreamTest do
  use ExUnit.Case

  @video "priv/video.mkv"

  setup do
    [
      duration: Exstream.probe(@video) |> Exstream.get_duration()
    ]
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

  test "it should get next step index", context do
    assert context[:duration]
           |> Exstream.get_steps()
           |> Exstream.get_next_step_index(0) === 1
  end

  test "it should segment" do
    assert is_binary Exstream.segment(@video, 3)
  end
end
