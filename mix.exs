defmodule Manticore.MixProject do
  use Mix.Project

  def project do
    [
      app: :manticore,
      escript: escript_config(),
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.2"}
    ]
  end

  defp escript_config do
    [
      main_module: Manticore,
      path: "_build/escript/manticore"
    ]
  end
end
