Mix.install([:plug, :plug_cowboy])

defmodule Exstream.Playground do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Welcome")
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end

require Logger
{:ok, _} = Plug.Cowboy.http(Exstream.Playground, [])
Logger.info("Plug now running on localhost:4000")