defmodule ExstreamTest do
  use ExUnit.Case

  test "it should have packet" do
    assert Exstream.probe("support/sample_1080_libx264_aac_30s_video.mkv")
    |> Enum.at(0) === %{"flags" => "K_", "pos" => "2563", "pts_time" => "0.054000"}
  end
end