# "Full bar" as in "both 'bar' and 'blank'".
defmodule ProgressBar.FullBarWidth do
  alias ProgressBar.Utils

  @min_bar_width 1
  @max_bar_width 100

  def determine(terminal_width_config, other_text) do
    available_width = terminal_width(terminal_width_config)
    other_width = other_text |> Utils.strip_invisibles() |> String.length()
    remaining_width = available_width - other_width

    clamp(remaining_width, @min_bar_width, @max_bar_width)
  end

  defp terminal_width(config) do
    case config do
      :auto -> ProgressBar.TerminalWidth.determine()
      fixed_value -> fixed_value
    end
  end

  defp clamp(number, min_value, max_value) do
    number |> min(max_value) |> max(min_value)
  end
end
