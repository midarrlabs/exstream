defmodule ExstreamTest do
  use ExUnit.Case

  test "it should have packet" do
    assert Exstream.probe("support/sample__1080__libx264__aac__30s__video.mkv")
    |> Enum.at(0) === %{"flags" => "K_", "pos" => "2563", "pts_time" => "0.054000"}
  end
end