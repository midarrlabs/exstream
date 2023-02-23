defmodule Exstream do

  def get_one_tenth(n) do
    floor(n / 10)
  end

  def get_steps(n) do
    Enum.to_list(0..floor(n) // get_one_tenth(n))
  end

  def get_step(duration, step) do
    Enum.at(get_steps(duration), step)
  end

  def get_next_step_index(steps, step) do
    Enum.find_index(steps, fn x -> x > step end)
  end

  def segment(file, step) do
    duration = 30
    next_step = Enum.at(get_steps(duration), get_next_step_index(get_steps(duration), step))

    {result, _exit_status} = System.cmd("ffmpeg", [
      "-hide_banner",
      "-loglevel", "error",
      "-copyts",
      "-ss", "#{ step }",
      "-i", file,
      "-c", "copy",
      "-to", "#{ next_step }",
      "-f", "mpegts",
      "pipe:"
    ])

    result
  end
end
