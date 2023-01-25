defmodule Exstream do

  def get_closest_packet_to_byte(packets, byte) do
    Enum.min_by(packets, fn x -> abs(String.to_integer(x["pos"]) - byte) end)
  end

  def get_packets(%{"packets" => packets}) do
    packets
  end

  def get_duration(%{"format" => %{"duration" => duration}}) do
    String.to_float(duration)
  end

  def get_timestamp(%{"pts_time" => timestamp}) do
    String.to_float(timestamp)
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
