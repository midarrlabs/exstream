defmodule Exstream.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Exstream.Router, port: 4040}
    ]

    opts = [strategy: :one_for_one, name: Exstream.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
