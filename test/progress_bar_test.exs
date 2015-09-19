defmodule ProgressBarTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test ".render(current..total)" do
    assert capture_io(fn -> ProgressBar.render(0..3) end) == "\r|   |   0%"
    assert capture_io(fn -> ProgressBar.render(1..3) end) == "\r|=  |  33%"
    assert capture_io(fn -> ProgressBar.render(2..3) end) == "\r|== |  67%"
    assert capture_io(fn -> ProgressBar.render(3..3) end) == "\r|===| 100%"
  end

  test "custom format" do
    format = [
      bar: "X",
      blank: ".",
      left: "(",
      right: ")",
      percent: false,
    ]
    assert capture_io(fn -> ProgressBar.render(2..3, format) end) == "\r(XX.)"
  end

  test "custom format falls back to defaults" do
    format = [bar: "X", right: "]"]
    assert capture_io(fn -> ProgressBar.render(2..3, format) end) == "\r|XX ]  67%"
  end

  test ".done" do
    assert capture_io(fn -> ProgressBar.done end) == "\n"
  end
end
