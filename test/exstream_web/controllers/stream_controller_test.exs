defmodule ExstreamWeb.StreamControllerTest do
  use ExstreamWeb.ConnCase

  test "GET /api/stream", %{conn: conn} do
    conn = get(conn, ~p"/api/stream")

    assert conn.status === 200
    assert conn.resp_body === File.read!("dev/stream/stream.mpd")
  end
end
