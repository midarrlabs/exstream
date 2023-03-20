defmodule Exstream.Application do
  use Application

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Exstream.Supervisor]
    Supervisor.start_link([], opts)
  end
end
