defmodule ProgressBar.Spinner do
  alias ProgressBar.Utils

  @default_format [
    frames: :strokes,
    spinner_color: [],
    text: "Loading…",
    done: "Loaded.",
    interval: 500,
  ]

  @themes [
    strokes:  ~w[/ - \\ |],
    braille: ~w[⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏],  # Stolen from WebTranslateIt
    bars: ~w[▁ ▂ ▃ ▄ ▅ ▆ ▇ █ ▇ ▆ ▅ ▄ ▃],  # http://stackoverflow.com/a/2685827/6962
  ]

  def render(custom_format \\ @default_format, fun) do
    format = Keyword.merge(@default_format, custom_format)

    config = [
      interval: format[:interval],
      render_frame: fn (count) -> render_frame(format, count) end,
      render_done:  fn -> render_done(format) end,
    ]

    ProgressBar.AnimationServer.start(config)
    value = fun.()
    ProgressBar.AnimationServer.stop
    value
  end

  defp render_frame(format, count) do
    frames = get_frames(format[:frames])
    index = rem(count, length(frames))
    frame = Enum.at(frames, index)

    IO.write [
      Utils.ansi_prefix,
      color(frame, format[:spinner_color]),
      " ",
      format[:text],
    ]
  end

  defp render_done(format) do
    IO.write [
      Utils.ansi_prefix,
      format[:done],
      "\n",
    ]
  end

  defp get_frames(theme) when is_atom(theme), do: Dict.fetch!(@themes, theme)
  defp get_frames(list) when is_list(list), do: list

  defp color(content, []), do: content
  defp color(content, ansi_codes) do
    [ ansi_codes, content, IO.ANSI.reset ]
  end
end