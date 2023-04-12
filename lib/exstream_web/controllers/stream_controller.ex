defmodule ExstreamWeb.StreamController do
  use ExstreamWeb, :controller

    def index(conn, _params) do
      conn
      |> send_resp(200, "ok")
    end
end
