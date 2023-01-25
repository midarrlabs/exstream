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

  def get_step_for_timestamp(steps, timestamp) do
    Enum.find(steps, fn x -> x > timestamp end)
  end

  def get_start_timestamp_for_path(path, bytes) do
    probe(path)
    |> get_packets()
    |> get_closest_packet_to_bytes(bytes)
    |> get_timestamp()
  end

  def get_string_start_timestamp_for_path(path, bytes) do
    get_start_timestamp_for_path(path, bytes)
    |> Float.to_string()
  end

  def get_end_timestamp_for_path(path, timestamp) do
    probe(path)
    |> get_duration()
    |> get_steps()
    |> get_step_for_timestamp(timestamp)
    |> Integer.to_string()
  end
end
