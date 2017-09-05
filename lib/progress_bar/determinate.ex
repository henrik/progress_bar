defmodule ProgressBar.Determinate do
  alias ProgressBar.Bytes

  @default_format [
    bar: "=",
    blank: " ",
    left: "|",
    right: "|",
    percent: true,
    bytes: false,
    suffix: false,
    bar_color: [],
    blank_color: [],
    width: :auto,
  ]

  def render(current, total, custom_format \\ @default_format)
  def render(current, total, custom_format) when current <= total do
    format =
      @default_format
      |> Keyword.merge(custom_format)
      |> Enum.into(%{})

    percent = current / total * 100 |> round

    suffix = [
      formatted_percent(format[:percent], percent),
      format |> get_suffix() |> formatted_suffix(current, total),
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

  defp get_suffix(%{suffix: false, bytes: true}), do: :bytes
  defp get_suffix(%{suffix: suffix}), do: suffix

  defp formatted_percent(false, _) do
    ""
  end
  defp formatted_percent(true, number) do
    number
    |> Integer.to_string()
    |> String.pad_leading(4)
    |> Kernel.<>("%")
  end

  defp formatted_suffix(:count, total, total), do: " (#{total})"
  defp formatted_suffix(:count, current, total), do: " (#{current}/#{total})"
  defp formatted_suffix(:bytes, total, total), do: " (#{Bytes.format(total)})"
  defp formatted_suffix(:bytes, current, total), do: " (#{Bytes.format(current, total)})"
  defp formatted_suffix(false, _, _), do: ""

  defp newline_if_complete(total, total), do: "\n"
  defp newline_if_complete(_, _), do: ""
end
