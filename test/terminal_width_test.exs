defmodule TerminalWidthTest do
  use ExUnit.Case

  test "returns a positive number" do
    assert ProgressBar.TerminalWidth.determine > 0
  end
end
