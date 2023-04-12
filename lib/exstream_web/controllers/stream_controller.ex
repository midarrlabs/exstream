defmodule ExstreamWeb.StreamController do
  use ExstreamWeb, :controller

    def index(conn, %{"path" => path, "start" => start, "end" => finish}) do

        Exile.stream!([
          "ffmpeg",
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
