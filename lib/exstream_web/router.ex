defmodule Exstream.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_file(200, Path.absname("lib/exstream_web/index.html"))
  end

  get "/video" do
    %Plug.Conn{req_headers: headers} = conn

    Exstream.SendVideo.send_video(conn, headers, Path.absname("support/sample_1080_libx264_aac_30s_video.mkv"))
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end

require Logger
Logger.info("Plug now running on localhost:4040")