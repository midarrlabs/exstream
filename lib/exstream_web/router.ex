defmodule Exstream.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    conn
    |> put_resp_content_type("text/html")
    |> send_file(200, Path.absname("lib/exstream_web/index.html"))
  end

  get "/segment:query" do
    %{"start" => start, "end" => finish} = fetch_query_params(conn).query_params

    Exstream.stream(%Exstream{
      conn: conn,
      path: "priv/h264-mp3.mkv",
      start: start,
      end: finish
    })
  end

  get "/playlist.m3u8" do
    conn
    |> send_resp(
      200,
      Exstream.Playlist.build(%Exstream.Playlist{
        duration: "00:00:30",
        url: "/segment?token=some-token"
      })
    )
  end

  get "/range.mp4" do
    Exstream.Range.stream(%Exstream.Range{conn: conn, path: "priv/h264-mp3.mkv"})
  end


  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
