defmodule ProgressBar.TerminalWidth do
  @fallback 80

  def determine do
    case :io.columns() do
      {:ok, count} -> count
      _ -> @fallback
    end
  end
end
