defmodule Exstream do
  import Plug.Conn

  def get_result({result, 0}) do
    result
  end

  def get_result({result, ""}) do
    result
  end

  def get_closest_packet_to_bytes(packets, byte) do
    Enum.min_by(packets, fn x -> abs((Integer.parse(x["pos"]) |> get_result()) - byte) end)
  end

  def get_packets(%{"packets" => packets}) do
    packets
  end

  def get_duration(%{"format" => %{"duration" => duration}}) do
    Float.parse(duration)
    |> get_result()
  end

  def get_timestamp(%{"pts_time" => timestamp}) do
    Float.parse(timestamp)
    |> get_result()
  end

  def get_steps(n) do
    Enum.to_list(0..floor(n) // floor(n / 10))
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

  def get_max_step(steps, timestamp) do
    Enum.find(steps, fn x -> x > timestamp end)
  end

  def get_start(path, bytes) do
    probe(path)
    |> get_packets()
    |> get_closest_packet_to_bytes(bytes)
    |> get_timestamp()
  end

  def get_end(path, timestamp) do
    probe(path)
    |> get_duration()
    |> get_steps()
    |> get_max_step(timestamp)
  end
  
  def random_string() do
    for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>
  end

  @spec chunk(String.t, number, String.t) :: String.t
  def chunk(path, bytes, chunk_id) do
    System.cmd("ffmpeg", [
      "-loglevel", "error",
      "-ss", "#{ get_start(path, bytes) }",
      "-i", path,
      "-to", "#{ get_end(path, get_start(path, bytes)) }",
      "-c", "copy",
      "#{ chunk_id }.mp4"
    ])

    "#{ chunk_id }.mp4"
  end

  def handle_range({"range", "bytes=0-1"}, conn, path, file_size) do
    conn
    |> put_resp_header("content-range", "bytes 0-1/#{file_size}")
    |> send_file(206, path, 0, 2)
  end

  def handle_range({"range", "bytes=" <> start_pos}, conn, path, file_size) do
    offset = String.split(start_pos, "-")
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
end
