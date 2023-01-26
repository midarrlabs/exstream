Mix.install([:plug, :plug_cowboy])

defmodule MyPlug do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world")
  end
end

require Logger
{:ok, _} = Plug.Cowboy.http(MyPlug, [])
Logger.info("Plug now running on localhost:4000")