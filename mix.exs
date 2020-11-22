defmodule ProgressBar.Mixfile do
  use Mix.Project

  def project do
    [
      app: :progress_bar,
      version: "2.0.1",
      elixir: "~> 1.3",
      description: "Command-line progress bars and spinners.",
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  def package do
    [
      maintainers: ["Henrik Nyh"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/henrik/progress_bar"}
    ]
  end

  defp deps do
    [
      {:decimal, "~> 2.0"}
    ]
  end
end
