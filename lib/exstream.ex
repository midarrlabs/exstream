defmodule Exstream do
  import Plug.Conn

  defstruct [:conn, :path, :start, :end]

  @type t :: %__MODULE__{conn: %Plug.Conn{}, path: String.t(), start: String.t(), end: String.t()}

  def stream(%Exstream{conn: %Plug.Conn{} = conn, path: path, start: start, end: finish}) do
    Exile.stream!([
      "ffmpeg",
      "-hide_banner",
      "-loglevel", "error",
      "-copyts",
      "-ss", "#{ start }",
      "-i", "#{ path }",
      "-c", "copy",
      "-to", "#{ finish }",
      "-f", "mpegts",
      "pipe:1"
    ])
    |> Enum.into(
      conn
      |> send_chunked(200)
    )
  end
end
