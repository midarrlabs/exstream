defmodule ExstreamWeb.ChunkControllerTest do
  use ExstreamWeb.ConnCase

  test "GET /api/:id", %{conn: conn} do
    conn = get(conn, ~p"/api/init-stream0.m4s")

    assert conn.status === 200
  end
end
