defmodule ExstreamWeb.PlaylistControllerTest do
  use ExstreamWeb.ConnCase

  test "GET /api/playlist.m3u8", %{conn: conn} do
    conn = get(conn, ~p"/api/playlist.m3u8")

    assert conn.status === 200
    assert conn.resp_body === File.read!("test/fixtures/playlist.m3u8")
  end
end
