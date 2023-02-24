defmodule Exstream.Duration.Test do
  use ExUnit.Case

  test "it should parse invalid duration" do
    assert Exstream.Duration.parse_duration("1:40:30") === "01:40:30"
  end

  test "it should parse duration" do
    assert Exstream.Duration.parse_duration("01:40:30") === "01:40:30"
  end

  test "it should get duration second" do
    assert Exstream.Duration.get_duration_second("1:40:30") === 30
  end

  test "it should get duration minute" do
    assert Exstream.Duration.get_duration_minute("1:40:30") === 40
  end

  test "it should get duration hour" do
    assert Exstream.Duration.get_duration_hour("1:40:30") === 1
  end
end
