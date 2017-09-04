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
    width: :auto,
  ]

  def render(current, total, custom_format \\ @default_format)
    when current <= total
  do
    format = Keyword.merge(@default_format, custom_format)

    percent = current / total * 100 |> round

    suffix = [
      formatted_percent(format[:percent], percent),
      bytes(format[:bytes], current, total),
      newline_if_complete(current, total),
    ]

    ProgressBar.BarFormatter.write(
      format,
      {format[:bar], format[:bar_color], percent},
      {format[:blank], format[:blank_color]},
      suffix
    )
  end

  # Private

  defp formatted_percent(false, _), do: ""
  defp formatted_percent(true, number) do
    " " <> String.pad_leading(Integer.to_string(number), 3) <> "%"
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
