defmodule Exstream do

  def get_closest_packet_to_byte(packets, byte) do
    Enum.min_by(packets, fn x -> abs(String.to_integer(x["pos"]) - byte) end)
  end

  def get_packets({ result, 0 }) do
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
