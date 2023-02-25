defmodule Exstream.Duration.Test do
  use ExUnit.Case

  @doc """
  *
  * 0:07 (7 seconds) should be 00:00:07
  *
  """
  test "it should parse 7 seconds" do
    assert Exstream.Duration.parse("0:07") === 7
  end

  @doc """
  *
  * 0:30 (30 seconds) should be 00:00:30
  *
  """
  test "it should parse 30 seconds" do
    assert Exstream.Duration.parse("0:30") === 30
  end

  @doc """
  *
  * 1:00 (1 minute) should be 00:01:00
  *
  """
  test "it should parse 1 minute to 60 seconds" do
    assert Exstream.Duration.parse("1:00") === 60
  end

  @doc """
  *
  * 12:12 (12 minutes, 12 seconds) should be 00:12:12
  *
  """
  test "it should parse 12 minutes 12 seconds to 732 seconds" do
    assert Exstream.Duration.parse("12:12") === 732
  end

  @doc """
  *
  * 1:23:04 (1 hour, 23 minutes, 4 seconds) should be 01:23:04
  *
  """
  test "it should parse 1 hour 23 minutes 4 seconds to 4984 seconds" do
    assert Exstream.Duration.parse("1:23:04") === 4984
  end

  @doc """
  *
  * 12:23:04 (12 hours, 23 minutes, 4 seconds) should be 12:23:04
  *
  """
  test "it should parse 12 hours 23 minutes 4 seconds to 44583 seconds" do
    assert Exstream.Duration.parse("12:23:04") === 44584
  end

  test "it should get seconds" do
    assert Exstream.Duration.get_second("1:40:30") === 30
  end

  test "it should get second" do
    assert Exstream.Duration.get_second("1:40:03") === 3
  end

  test "it should get minutes" do
    assert Exstream.Duration.get_minute("1:40:30") === 40
  end

  test "it should get minute" do
    assert Exstream.Duration.get_minute("1:04:30") === 4
  end

  test "it should get hours" do
    assert Exstream.Duration.get_hour("25:40:30") === 25
  end

  test "it should get hour" do
    assert Exstream.Duration.get_hour("2:40:30") === 2
  end
end
