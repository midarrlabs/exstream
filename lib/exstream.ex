defmodule Exstream do

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
    {integer, _remainder_of_binary} = Integer.parse(duration)

    integer
  end

  def get_result({result, 0}) do
    result
  end

  def get_one_tenth(n) do
    floor(n / 10)
  end

  def get_steps(n) do
    Enum.to_list(0..floor(n) // get_one_tenth(n))
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
