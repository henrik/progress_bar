defmodule ProgressBar do
  @default_format [
    bar: "=",
    blank: " ",
    left: "|",
    right: "|",
    percent: true,
  ]

  def render(current..total, custom_format \\ @default_format) do
    format = Keyword.merge(@default_format, custom_format)

    bar = String.duplicate(format[:bar], current)
    blank = String.duplicate(format[:blank], total - current)

    IO.write [
      "\r",
      format[:left],
      bar,
      blank,
      format[:right],
      formatted_percent(format[:percent], current, total),
    ]
  end

  def done do
    IO.write "\n"
  end

  # Private

  defp formatted_percent(false, _current, _total), do: ""
  defp formatted_percent(true, current, total) do
    percent = current / total * 100
    pretty = percent |> Float.round |> trunc |> Integer.to_string
    " " <> String.rjust(pretty, 3) <> "%"
  end
end
