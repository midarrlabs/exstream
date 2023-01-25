defmodule ExstreamTest do
  use ExUnit.Case

  @path "test/fixtures/sample_1080_libx264_aac_30s_video.mkv"

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

  test "it should get timestamp" do
    assert Exstream.get_start(@path, 18447) === 0.121
  end

  test "it should get timestamp as string" do
    assert Exstream.get_start_string(@path, 18447) === "0.121"
  end

  test "it should get timestamp step 3" do
    assert Exstream.get_end(@path, 0.054) === "3"
  end

  test "it should get timestamp step 9" do
    assert Exstream.get_end(@path, 6.054) === "9"
  end

  test "it should get timestamp step 21" do
    assert Exstream.get_end(@path, 18.054) === "21"
  end
end