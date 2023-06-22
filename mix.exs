defmodule Exstream.MixProject do
  use Mix.Project

  def project do
    [
      app: :exstream,
      version: "0.20.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      description: "Pluggable video streams",
      package: [
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/midarrlabs/exstream"}
      ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:plug, "~> 1.13"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.4"},
      {:exile, "~> 0.5.0"},
      {:extaima, "~> 0.3.0"}
    ]
  end
end
