defmodule ExstreamWeb.StreamControllerTest do
  use ExstreamWeb.ConnCase

  test "GET /api/stream", %{conn: conn} do
    conn = get(conn, ~p"/api/stream?path=dev/sample__1080__libx265__ac3__30s__video.mkv&start=0&end=10")

    assert conn.status === 200
  end
end
