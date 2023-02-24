defmodule Exstream.Duration.Test do
  use ExUnit.Case

  test "it should parse invalid" do
    assert Exstream.Duration.parse("1:40:30") === "01:40:30"
  end

  test "it should parse" do
    assert Exstream.Duration.parse("01:40:30") === "01:40:30"
  end

  test "it should get second" do
    assert Exstream.Duration.get_second("1:40:30") === 30
  end

  test "it should get minute" do
    assert Exstream.Duration.get_minute("1:40:30") === 40
  end

  test "it should get hour" do
    assert Exstream.Duration.get_hour("1:40:30") === 1
  end
end
