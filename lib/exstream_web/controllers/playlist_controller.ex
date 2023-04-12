defmodule ExstreamWeb.PlaylistController do
  use ExstreamWeb, :controller

    defp get_extinf(duration, url) do
      steps = floor((Extaima.parse(duration) |> Extaima.seconds()) / 10)

      Enum.map_join(1..steps, fn step ->
        "#EXTINF:10,\n#{url}?start=#{step * 10 - 10}&end=#{step * 10}\n"
      end)
    end

    def build(duration, url) do
      "#EXTM3U\n" <>
        "#EXT-X-PLAYLIST-TYPE:VOD\n" <>
        "#EXT-X-TARGETDURATION:10\n" <>
        "#EXT-X-VERSION:4\n" <>
        "#EXT-X-MEDIA-SEQUENCE:0\n" <>
        get_extinf(duration, url) <>
        "#EXT-X-ENDLIST"
    end

    def index(conn, %{"duration" => duration, "url" => url}) do
      conn
      |> send_resp(200, build(duration, url))
    end
end
