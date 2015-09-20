defmodule ProgressBar.Indeterminate do
  @default_format [
    bars: ["-=", "=-"],
    done: "=",
    left: "|",
    right: "|",
    bars_color: [],
    done_color: [],
    interval: 500,
  ]

  def render(custom_format \\ @default_format) do
    format = Keyword.merge(@default_format, custom_format)

    ProgressBar.IndeterminateServer.start(format)
  end

  def terminate do
    ProgressBar.IndeterminateServer.stop
  end
end
