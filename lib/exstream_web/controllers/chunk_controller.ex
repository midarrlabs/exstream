defmodule ExstreamWeb.ChunkController do
  use ExstreamWeb, :controller

    def index(conn, %{"id" => id}) do
      conn
      |> send_file(200, "dev/stream/#{ id }")
    end
end
