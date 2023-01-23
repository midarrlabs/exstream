defmodule Exstream do

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
