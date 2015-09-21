defmodule ProgressBar.Formatter do
  # This may become ANSI.IO.clear_line sometime after Elixir 1.1.0:
  # https://github.com/elixir-lang/elixir/pull/3755
  @ansi_clear_line "\e[2K"

  def write(format, bar, suffix \\ "") do
    IO.write [
      @ansi_clear_line, # So a shorter line can replace a previous, longer line.
      "\r", # Back to beginning of line.
      format[:left],
      bar,
      format[:right],
      suffix,
    ]
  end
end
