defmodule Exstream do
  import Plug.Conn

  defstruct [:conn, :path, :start, :end]

  @type t :: %__MODULE__{conn: %Plug.Conn{}, path: String.t(), start: String.t(), end: String.t()}

  def stream(%Exstream{conn: %Plug.Conn{} = conn, path: path, start: start, end: finish}) do
    Exile.stream!([
      "ffmpeg",
      "-hide_banner",
      "-loglevel", "error",
      "-ss", "#{ start }",
      "-i", "#{ path }",
      "-to", "#{ finish }",
      "-copyts",
      "-c:v", "libx264",
      "-preset", "faster",
      "-profile:v", "high",
      "-level:v", "4.0",
      "-c:a", "aac",
      "-ac", "2",
      "-f", "mpegts",
      "pipe:1"
    ])
    |> Enum.into(
      conn
      |> send_chunked(200)
    )
  end
end
