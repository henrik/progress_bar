defmodule DeterminateTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import ProgressBarAssertions

  test "renders a bar" do
    assert_bar ProgressBar.render(0, 3) == "|                                                                                                    |   0%"
    assert_bar ProgressBar.render(1, 3) == "|=================================                                                                   |  33%"
    assert_bar ProgressBar.render(2, 3) == "|===================================================================                                 |  67%"
    assert_bar ProgressBar.render(3, 3) == "|====================================================================================================| 100%"
  end

  test "includes ANSI sequences to clear and re-write the line" do
    bar = capture_io(fn -> ProgressBar.render(1, 1) end)
    assert String.starts_with?(bar, "\e[2K\r")
  end

  test "adds a newline when complete" do
    incomplete_bar = capture_io(fn -> ProgressBar.render(1, 2) end)
    completed_bar = capture_io(fn -> ProgressBar.render(2, 2) end)

    refute String.ends_with?(incomplete_bar, "\n")
    assert String.ends_with?(completed_bar, "\n")
  end

  test "custom format" do
    format = [
      bar: "X",
      blank: ".",
      left: "(",
      right: ")",
      percent: false,
    ]
    assert_bar ProgressBar.render(2, 3, format) == "(XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.................................)"
  end

  test "custom format falls back to defaults" do
    format = [bar: "X", right: "]"]
    assert_bar ProgressBar.render(2, 3, format) == "|XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                 ]  67%"
  end

  test "custom color" do
    format = [
      bar_color: [IO.ANSI.white, IO.ANSI.green_background],
      blank_color: IO.ANSI.red_background,
    ]

    bar = capture_io(fn -> ProgressBar.render(1, 2, format) end)

    assert bar =~ IO.chardata_to_string(["|", IO.ANSI.white, IO.ANSI.green_background, "="])
    assert bar =~ IO.chardata_to_string(["=", IO.ANSI.reset, IO.ANSI.red_background, " "])
    assert bar =~ IO.chardata_to_string([" ", IO.ANSI.reset])
  end

  test "bytes: true" do
    mb = 1_048_576
    assert_bar ProgressBar.render(0, mb, bytes: true)      == "|                                                                                                    |   0% (0.00/1.00 MB)"
    assert_bar ProgressBar.render((mb/2), mb, bytes: true) == "|==================================================                                                  |  50% (0.50/1.00 MB)"
    assert_bar ProgressBar.render(mb, mb, bytes: true)     == "|====================================================================================================| 100% (1.00 MB)"
  end
end
