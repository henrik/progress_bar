defmodule ProgressBarTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test ".render(current..total)" do
    assert capture_io(fn -> ProgressBar.render(0..3) end) == "\r|   |"
    assert capture_io(fn -> ProgressBar.render(1..3) end) == "\r|=  |"
    assert capture_io(fn -> ProgressBar.render(2..3) end) == "\r|== |"
    assert capture_io(fn -> ProgressBar.render(3..3) end) == "\r|===|"
  end

  test ".render with custom format" do
    format = [bar: "X", blank: "O", left: ":", right: ""]
    assert capture_io(fn -> ProgressBar.render(2..3, format) end) == "\r:XXO"
  end

  test ".render with custom format falls back to defaults" do
    format = [bar: "X", right: "]"]
    assert capture_io(fn -> ProgressBar.render(2..3, format) end) == "\r|XX ]"
  end

  test ".done" do
    assert capture_io(fn -> ProgressBar.done end) == "\n"
  end
end
