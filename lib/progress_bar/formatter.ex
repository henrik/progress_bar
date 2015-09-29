defmodule ProgressBar.Formatter do
  alias ProgressBar.Utils

  # This may become ANSI.IO.clear_line sometime after Elixir 1.1.0:
  # https://github.com/elixir-lang/elixir/pull/3755
  @ansi_clear_line "\e[2K"

  # Full-width bar, with no blank (i.e. indeterminate).
  def write(format, {bar, bar_color}, suffix) do
    write(format, {bar, bar_color, 100}, {"", []}, suffix)
  end

  # Bar + blank.
  def write(format, {bar, bar_color, bar_percent}, {blank, blank_color}, suffix) do
    full_bar_width = full_bar_width(format, suffix)

    bar_width = bar_percent / 100 * full_bar_width |> Float.round |> trunc
    blank_width = full_bar_width - bar_width

    write_bar = [
      (bar |> repeat(bar_width) |> color(bar_color)),
      (blank |> repeat(blank_width) |> color(blank_color)),
    ]

    IO.write [
      left(format),
      write_bar,
      right(format, suffix),
    ]
  end

  defp left(format) do
    IO.chardata_to_string [
      @ansi_clear_line, # So a shorter line can replace a previous, longer line.
      "\r", # Back to beginning of line.
      format[:left],
    ]
  end

  defp right(format, suffix) do
    IO.chardata_to_string [
      format[:right],
      suffix,
    ]
  end

  defp full_bar_width(format, suffix) do
    other_text = left(format) <> right(format, suffix)
    ProgressBar.FullBarWidth.determine(format[:width], other_text)
  end

  defp repeat(bar, width) do
    bar
    |> String.graphemes
    |> Stream.cycle
    |> Enum.take(width)
    |> Enum.join
  end

  defp color(content, []), do: content
  defp color(content, ansi_codes) do
    [ ansi_codes, content, IO.ANSI.reset ]
  end
end
