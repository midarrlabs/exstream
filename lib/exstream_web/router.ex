defmodule Exstream.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  @video "test/fixtures/video.mkv"
  @audio "test/fixtures/audio.mp3"

  get "/watch" do
    conn
    |> put_resp_content_type("text/html")
    |> send_file(200, Path.absname("lib/exstream_web/index.html"))
  end

  get "/segments/:step" do
    conn
    |> send_resp(200, Exstream.segment(@video, String.to_integer(step)))
  end

  get "/playlist.m3u8" do
    conn
    |> send_resp(200, Exstream.Playlist.build(%Exstream.Playlist{duration: 30, url: "/some/base/url?token=some-token"}))
  end

  get "/audio.mp3" do
    Exstream.Range.get_video(conn, Path.absname(@audio))
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end

require Logger
Logger.info("Plug now running on localhost:4040")
