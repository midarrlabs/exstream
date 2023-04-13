defmodule ExstreamWeb.PageController do
  use ExstreamWeb, :controller

    def index(conn, %{"path" => path, "duration" => duration}) do
      render(conn
        |> assign(:path, path)
        |> assign(:duration, duration),
      :index, layout: false)
    end

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
end
