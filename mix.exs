defmodule ProgressBar.Mixfile do
  use Mix.Project

  def project do
    [
      app: :progress_bar,
      version: "0.0.13",
      elixir: "~> 1.0",
      description: "Text progress bars.",
      package: package,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
    ]
  end

  def application do
    [applications: [:logger]]
  end

  def package do
    [
      maintainers: ["Henrik Nyh"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/henrik/progress_bar"}
    ]
  end

  defp deps do
    []
  end
end
