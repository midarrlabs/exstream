defmodule ExstreamTest do
  use ExUnit.Case

  @sample "test/fixtures/sample_1080_libx264_aac_30s_video.mkv"

  test "it should have packet" do
    assert Exstream.probe(@sample)
    |> Enum.at(0) === %{"flags" => "K_", "pos" => "2563", "pts_time" => "0.054000"}
  end
end