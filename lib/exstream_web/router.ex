defmodule Exstream.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_file(200, Path.absname("lib/exstream_web/index.html"))
  end

  get "/playlist.m3u8" do
    conn
    |> send_resp(200, Exstream.Playlist.build(Path.absname("support/sample_1080_libx264_aac_30s_video.mkv")))
  end

  get "/start" do
    conn
    |> send_resp(200, Exstream.segment("support/sample_1080_libx264_aac_30s_video.mkv", 0))
  end

  get "/audio.mp3" do
    Exstream.Range.video(conn, Path.absname("support/audio.mp3"))
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end

require Logger
Logger.info("Plug now running on localhost:4040")
