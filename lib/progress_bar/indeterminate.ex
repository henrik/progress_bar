defmodule ProgressBar.Indeterminate do
  @default_format [
    bars: ["=---", "-=--", "--=-", "---="],
    done: "=",
    left: "|",
    right: "|",
    bars_color: [],
    done_color: [],
    interval: 500,
  ]

  def render(custom_format \\ @default_format, fun) do
    format = Keyword.merge(@default_format, custom_format)

    ProgressBar.IndeterminateServer.start(format)
    value = fun.()
    ProgressBar.IndeterminateServer.stop
    value
  end
end
