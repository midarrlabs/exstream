defmodule Exstream.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  @video "priv/video.mkv"

  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_file(200, Path.absname("lib/exstream_web/index.html"))
  end

  get "/segment:query" do
    %{"start" => start, "end" => finish} = fetch_query_params(conn).query_params

    Exile.stream!(~w(ffmpeg -copyts  -ss #{ start } -i #{ @video } -c copy -to #{ finish } -f mpegts pipe:1))
    |> Enum.into(
         conn
         |> send_chunked(200)
       )
  end

  get "/playlist.m3u8" do
    conn
    |> send_resp(200, Exstream.Playlist.build(%Exstream.Playlist{duration: "00:00:30", url: "/segment?token=some-token"}))
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end

require Logger
Logger.info("Plug now running on localhost:4040")
