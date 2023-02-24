defmodule Exstream.Test do
  use ExUnit.Case
  use Plug.Test

  @video "priv/Some Video (1234)/video.mkv"

  test "it should stream" do
    conn = Exstream.stream(%Exstream{
      conn: conn(:get, "/segment?start=0&end=20"),
      path: @video,
      start: 0,
      end: 20
    })

    assert conn.status === 200
  end
end
