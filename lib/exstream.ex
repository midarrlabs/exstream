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

  def get_packets({result, 0}) do
    result
    |> Jason.decode!()
    |> Map.get("packets")
  end

  def probe_for_packets(file) do
    System.cmd("ffprobe", [
      "-i", file,
      "-show_entries", "packet=pos,pts_time,flags",
      "-select_streams", "v",
      "-of", "json",
      "-v", "0"
    ])
    |> get_packets()
  end
end
