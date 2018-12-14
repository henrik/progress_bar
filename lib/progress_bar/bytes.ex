defmodule ProgressBar.Bytes do
  @mb 1_000_000
  @kb 1_000

  def format(bytes) do
    format_with_unit(bytes)
  end

  def format(current_bytes, total_bytes) do
    format_without_unit(current_bytes, total_bytes) <> "/" <> format_with_unit(total_bytes)
  end

  defp format_with_unit(bytes) do
    {_, unit} = divisor_and_unit(bytes)
    format_without_unit(bytes, bytes) <> " " <> unit
  end

  defp format_without_unit(bytes, bytes_to_determine_unit) do
    {divisor, _} = divisor_and_unit(bytes_to_determine_unit)
    to_s(bytes / divisor)
  end

  defp divisor_and_unit(bytes) when bytes < @mb, do: {@kb, "KB"}
  defp divisor_and_unit(_bytes), do: {@mb, "MB"}

  defp to_s(number) do
    # Always show 2 decimals. Looks jumpy otherwise when numbers change.
    # Float.floor has surprising behaviour.
    number |> to_decimal() |> Decimal.round(2, :floor) |> Decimal.to_string()
  end

  # Use from_float/1 if available, otherwise Decimal will loudly warn.
  if Keyword.has_key?(Decimal.module_info(:exports), :from_float) do
    defp to_decimal(float), do: Decimal.from_float(float)
  else
    defp to_decimal(float), do: Decimal.new(float)
  end
end
