defmodule ProgressBar.Bytes do
  def format(bytes) do
    "#{format_mb bytes} MB"
  end

  def format(current_bytes, total_bytes) do
    "#{format_mb current_bytes}/#{format_mb total_bytes} MB"
  end

  def format_mb(bytes) do
    bytes |> to_mb |> to_s
  end

  defp to_mb(bytes) do
    bytes / 1_048_576
  end

  defp to_s(number) do
    # Always show 2 decimals. Looks jumpy otherwise when numbers change.
    Float.to_string(number, decimals: 2)
  end
end
