defmodule ProgressBar do
  @ansi_clear_line "\e[2K"

  @default_format [
    bar: "=",
    blank: " ",
    left: "|",
    right: "|",
    percent: true,
    bytes: false,
  ]

  def render(current, total, custom_format \\ @default_format) do
    format = Keyword.merge(@default_format, custom_format)

    percent = current / total * 100 |> Float.round |> trunc

    bar = String.duplicate(format[:bar], percent)
    blank = String.duplicate(format[:blank], 100 - percent)

    IO.write [
      @ansi_clear_line, # So a shorter line can replace a previous, longer line.
      "\r", # Back to beginning of line.
      format[:left],
      bar,
      blank,
      format[:right],
      formatted_percent(format[:percent], percent),
      bytes(format[:bytes], current, total),
      newline_if_complete(current, total),
    ]
  end

  # Private

  defp formatted_percent(false, _), do: ""
  defp formatted_percent(true, number) do
    " " <> String.rjust(Integer.to_string(number), 3) <> "%"
  end

  defp bytes(false, _, _), do: ""
  defp bytes(true, total, total) do
    " (#{mb total} MB)"
  end
  defp bytes(true, current, total) do
    " (#{mb current}/#{mb total} MB)"
  end

  defp mb(bytes) do
    bytes / 1_048_576 |> Float.round(2)
  end

  defp newline_if_complete(total, total), do: "\n"
  defp newline_if_complete(_, _), do: ""
end
