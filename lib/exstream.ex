defmodule Exstream do
  import Plug.Conn

  defstruct [:conn, :path, :start, :end]

  @type t :: %__MODULE__{conn: %Plug.Conn{}, path: String.t(), start: String.t(), end: String.t()}

  def stream(%Exstream{conn: %Plug.Conn{} = conn, path: path, start: start, end: finish}) do
    Exile.stream!([
      "ffmpeg",
      "-copyts",
      "-ss", "#{ start }",
      "-i", "#{ path }",
      "-to", "#{ finish }",
      "-c:v", "copy",
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
