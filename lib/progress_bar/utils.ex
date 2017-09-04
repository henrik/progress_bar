defmodule ProgressBar.Utils do
  def ansi_prefix do
    [
      ansi_clear_line(), # So a shorter line can replace a previous, longer line.
      "\r", # Back to beginning of line.
    ] |> Enum.join
  end

  def strip_invisibles(string) do
    string |> String.replace(~r/\e\[\d*[a-zA-Z]|[\r\n]/, "")
  end

  def color(content, []), do: content
  def color(content, ansi_codes) do
    [ ansi_codes, content, IO.ANSI.reset ]
  end

  defp ansi_clear_line do
    # This may become ANSI.IO.clear_line sometime after Elixir 1.1.0:
    # https://github.com/elixir-lang/elixir/pull/3755
    "\e[2K"
  end
end
