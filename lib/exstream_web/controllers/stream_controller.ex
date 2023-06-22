defmodule ExstreamWeb.StreamController do
  use ExstreamWeb, :controller

    def index(conn, _params) do
      conn
      |> send_file(200, "dev/stream/stream.mpd")
    end
end
