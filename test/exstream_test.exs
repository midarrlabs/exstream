defmodule Exstream.Test do
  use ExUnit.Case
  use Plug.Test

  test "it should stream" do
    conn = conn(:get, "/segment?start=0&end=20")

    assert conn.query_string === "start=0&end=20"
  end
end
