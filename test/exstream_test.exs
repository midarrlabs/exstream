defmodule ExstreamTest do
  use ExUnit.Case
  doctest Exstream

  test "greets the world" do
    assert Exstream.hello() == :world
  end
end
