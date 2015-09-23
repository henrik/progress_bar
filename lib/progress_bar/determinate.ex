defmodule ProgressBar.Determinate do
  @default_format [
    bar: "=",
    blank: " ",
    left: "|",
    right: "|",
    percent: true,
    bytes: false,
    bar_color: [],
    blank_color: [],
  ]

  def render(current, total, custom_format \\ @default_format) do
    format = Keyword.merge(@default_format, custom_format)

    percent = current / total * 100 |> Float.round |> trunc

    bar = String.duplicate(format[:bar], percent)
    blank = String.duplicate(format[:blank], 100 - percent)

    write_bar = [
      color(bar, format[:bar_color]),
      color(blank, format[:blank_color]),
    ]

    write_suffix = [
      formatted_percent(format[:percent], percent),
      bytes(format[:bytes], current, total),
      newline_if_complete(current, total),
    ]

    ProgressBar.Formatter.write(format, write_bar, write_suffix)
  end

  # Private

  defp color(content, []), do: content
  defp color(content, ansi_codes) do
    [ ansi_codes, content, IO.ANSI.reset ]
  end

  defp formatted_percent(false, _), do: ""
  defp formatted_percent(true, number) do
    " " <> String.rjust(Integer.to_string(number), 3) <> "%"
  end

  defp bytes(false, _, _), do: ""
  defp bytes(true, total, total) do
    " (" <> ProgressBar.Bytes.format(total) <> ")"
  end
  defp bytes(true, current, total) do
    " (" <> ProgressBar.Bytes.format(current, total) <> ")"
  end

  defp newline_if_complete(total, total), do: "\n"
  defp newline_if_complete(_, _), do: ""
end
