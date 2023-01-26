defmodule Exstream do

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

  @spec chunk_video(String.t, number, String.t) :: String.t
  def chunk_video(path, bytes, chunk_id) do
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
end
