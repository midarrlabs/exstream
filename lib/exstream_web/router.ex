defmodule Exstream.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_file(200, Path.absname("lib/exstream_web/index.html"))
  end

  get "/playlist" do
    conn
    |> send_file(200, Path.absname("support/playlist.m3u8"))
  end

  get "/start" do
    conn
    |> send_file(200, Path.absname("support/start.ts"))
  end

  get "/end" do
    conn
    |> send_file(200, Path.absname("support/end.ts"))
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end

require Logger
Logger.info("Plug now running on localhost:4040")
