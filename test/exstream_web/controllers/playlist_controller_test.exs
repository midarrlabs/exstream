defmodule ExstreamWeb.PlaylistControllerTest do
  use ExstreamWeb.ConnCase

  test "GET /api/playlist", %{conn: conn} do
    conn = get(conn, ~p"/api/playlist")

    assert conn.status === 200
    assert conn.resp_body === "ok"
  end
end
