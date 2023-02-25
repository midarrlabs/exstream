defmodule Exstream.Playlist do
  defstruct [:duration, :url]

  @type t :: %Exstream.Playlist{duration: String.t(), url: String.t()}

  defp get_extinf(duration, url) do
    steps = floor((Extaima.parse(duration) |> Extaima.seconds()) / 10)

    Enum.map_join(1..steps, fn step ->
      "#EXTINF:10,\n#{url}&start=#{step * 10 - 10}&end=#{step * 10}\n"
    end)
  end

  def build(%Exstream.Playlist{duration: duration, url: url}) do
    "#EXTM3U\n" <>
      "#EXT-X-PLAYLIST-TYPE:VOD\n" <>
      "#EXT-X-TARGETDURATION:10\n" <>
      "#EXT-X-VERSION:4\n" <>
      "#EXT-X-MEDIA-SEQUENCE:0\n" <>
      get_extinf(duration, url) <>
      "#EXT-X-ENDLIST"
  end
end
