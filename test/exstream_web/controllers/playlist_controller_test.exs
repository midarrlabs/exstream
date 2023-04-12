defmodule ExstreamWeb.PlaylistControllerTest do
  use ExstreamWeb.ConnCase

  test "GET /api/playlist.m3u8", %{conn: conn} do
    conn = get(conn, ~p"/api/playlist.m3u8?duration=00:00:30&url=/some/url")

    assert conn.status === 200
    assert conn.resp_body === File.read!("test/fixtures/playlist.m3u8")
  end
end
