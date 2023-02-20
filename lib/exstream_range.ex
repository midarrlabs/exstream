defmodule Exstream.Range do
  import Plug.Conn

  def handle_range({"range", "bytes=0-1"}, conn, path, file_size) do
    conn
    |> put_resp_header("content-range", "bytes 0-1/#{file_size}")
    |> send_file(206, path, 0, 2)
  end

  def handle_range({"range", "bytes=" <> start_pos}, conn, path, file_size) do
    offset =
      String.split(start_pos, "-")
      |> List.first()
      |> String.to_integer()

    conn
    |> put_resp_header("content-range", "bytes #{offset}-#{file_size - 1}/#{file_size}")
    |> send_file(206, path, offset, file_size - offset)
  end

  def handle_range(nil, conn, path, file_size) do
    conn
    |> put_resp_header("content-range", "bytes 0-#{file_size - 1}/#{file_size}")
    |> send_file(206, path, 0, file_size)
  end

  def video(conn, path) do
    List.keyfind(conn.req_headers, "range", 0)
    |> handle_range(conn |> put_resp_header("content-type", "audio/mpeg"), path, File.stat!(path).size)
  end
end
