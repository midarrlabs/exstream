defmodule Exstream do
  import Plug.Conn

  def handle_range({"range", "bytes=0-1"}, conn, path, file_size) do
    conn
    |> put_resp_header("content-range", "bytes 0-1/#{file_size}")
    |> send_file(206, path, 0, 2)
  end

  def handle_range({"range", "bytes=" <> start_pos}, conn, path, file_size) do
    offset =
      String.split(start_pos, "-")
      |> List.first()
      |> String.to_integer()

    conn
    |> put_resp_header("content-range", "bytes #{offset}-#{file_size - 1}/#{file_size}")
    |> send_file(206, path, offset, file_size - offset)
  end

  def handle_range(nil, conn, path, file_size) do
    conn
    |> put_resp_header("content-range", "bytes 0-#{file_size - 1}/#{file_size}")
    |> send_file(206, path, 0, file_size)
  end

  def video(conn, path) do
    List.keyfind(conn.req_headers, "range", 0)
    |> handle_range(conn |> put_resp_header("content-type", "video/mp4"), path, File.stat!(path).size)
  end

  def get_closest_packet_to_byte(packets, byte) do
    Enum.min_by(packets, fn x -> abs(String.to_integer(x["pos"]) - byte) end)
  end

  def get_packets(%{"packets" => packets}) do
    packets
  end

  def get_keyframe_packets(%{"packets" => packets}) do
    packets
    |> Enum.filter(fn x -> x["flags"] === "K_" end)
  end

  def get_duration(%{"format" => %{"duration" => duration}}) do
    duration
  end

  def get_result({ result, 0 }) do
    result
  end

  def probe(file) do
    System.cmd("ffprobe", [
      "-i", file,
      "-show_entries", "format=duration:packet=pos,pts_time,flags",
      "-select_streams", "v",
      "-of", "json",
      "-v", "0"
    ])
    |> get_result()
    |> Jason.decode!()
  end
end
