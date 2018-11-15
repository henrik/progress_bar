defmodule ProgressBar.Indeterminate do
  @default_format [
    bars: ["=---", "-=--", "--=-", "---="],
    done: "=",
    left: "|",
    right: "|",
    bars_color: [],
    done_color: [],
    interval: 500,
    width: :auto
  ]

  def render(custom_format \\ @default_format, fun) do
    format = Keyword.merge(@default_format, custom_format)

    config = [
      interval: format[:interval],
      render_frame: fn count -> render_frame(format, count) end,
      render_done: fn -> render_done(format) end
    ]

    ProgressBar.AnimationServer.start(config)
    value = fun.()
    ProgressBar.AnimationServer.stop()
    value
  end

  defp render_frame(format, count) do
    parts = format[:bars]
    index = rem(count, length(parts))
    part = Enum.at(parts, index)

    ProgressBar.BarFormatter.write(
      format,
      {part, format[:bars_color]},
      ""
    )
  end

  defp render_done(format) do
    ProgressBar.BarFormatter.write(
      format,
      {format[:done], format[:done_color]},
      "\n"
    )
  end
end
