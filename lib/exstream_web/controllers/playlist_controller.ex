defmodule ExstreamWeb.PlaylistController do
  use ExstreamWeb, :controller

    defp get_extinf(url, path, duration) do
      steps = floor((Extaima.parse(duration) |> Extaima.seconds()) / 5)

      Enum.map_join(1..steps, fn step ->
        "#EXTINF:5,\n#{url}?path=#{path}&start=#{step * 5 - 5}&end=#{step * 5}\n"
      end)
    end

    def build(url, path, duration) do
      "#EXTM3U\n" <>
        "#EXT-X-PLAYLIST-TYPE:VOD\n" <>
        "#EXT-X-TARGETDURATION:5\n" <>
        "#EXT-X-VERSION:4\n" <>
        "#EXT-X-MEDIA-SEQUENCE:0\n" <>
        get_extinf(url, path, duration) <>
        "#EXT-X-ENDLIST"
    end

    def index(conn, %{"url" => url, "path" => path, "duration" => duration}) do
      conn
      |> send_resp(200, build(url, path, duration))
    end
end
