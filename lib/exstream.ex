defmodule Exstream do
  import Plug.Conn

  def get_result({result, 0}) do
    result
  end

  def get_result({result, ""}) do
    result
  end

  def probe(path) do
    System.cmd("ffprobe", [
      "-i", path,
      "-show_entries", "format=duration:packet=pos,pts_time,flags",
      "-select_streams", "v",
      "-of", "json",
      "-v", "0"
    ])
    |> get_result()
    |> Jason.decode!()
  end
  
  def random_string() do
    for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>
  end

  def handle_range({"range", "bytes=" <> positions}, conn, path) do
    start = String.split(positions, "-")
             |> List.first()
             |> String.to_integer()

    finish = String.split(positions, "-")
             |> List.last()
             |> String.to_integer()

    conn
    |> put_resp_header("content-type", "video/mp2t")
    |> put_resp_header("content-range", "bytes #{start}-#{finish - 1}/#{finish}")
    |> send_file(206, path, start, finish - start)
  end

  def get_video(conn, path) do
    List.keyfind(conn.req_headers, "range", 0)
    |> handle_range(conn, path)
  end

  def get_manifest(conn, path) do
    conn
    |> put_resp_header("content-type", "vnd.apple.mpegURL")
    |> send_file(200, path)
  end
end
