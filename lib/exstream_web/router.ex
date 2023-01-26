Mix.install([:plug, :plug_cowboy])

defmodule Exstream.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_file(200, Path.absname("lib/exstream_web/index.html"))
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end

require Logger
{:ok, _} = Plug.Cowboy.http(Exstream.Router, [])
Logger.info("Plug now running on localhost:4000")