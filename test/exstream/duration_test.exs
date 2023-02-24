defmodule Exstream.Duration.Test do
  use ExUnit.Case

  @doc """
  *
  * 0:07 (7 seconds) should be 00:00:07
  *
  """
  test "it should parse 7 seconds" do
    assert Exstream.Duration.parse("0:07") === "00:00:07"
  end

  @doc """
  *
  * 0:30 (30 seconds) should be 00:00:30
  *
  """
  test "it should parse 30 seconds" do
    assert Exstream.Duration.parse("0:30") === "00:00:30"
  end

  @doc """
  *
  * 1:00 (1 minute) should be 00:01:00
  *
  """
  test "it should parse 1 minute" do
    assert Exstream.Duration.parse("1:00") === "00:01:00"
  end

  @doc """
  *
  * 12:12 (12 minutes, 12 seconds) should be 00:12:12
  *
  """
  test "it should parse 12 minutes 12 seconds" do
    assert Exstream.Duration.parse("12:12") === "00:12:12"
  end

  @doc """
  *
  * 1:23:04 (1 hour, 23 minutes, 4 seconds) should be 01:23:04
  *
  """
  test "it should parse 1 hour 23 minutes 4 seconds" do
    assert Exstream.Duration.parse("1:23:04") === "01:23:04"
  end

  @doc """
  *
  * 12:23:04 (12 hours, 23 minutes, 4 seconds) should be 12:23:04
  *
  """
  test "it should parse 12 hours 23 minutes 4 seconds" do
    assert Exstream.Duration.parse("12:23:04") === "12:23:04"
  end

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
