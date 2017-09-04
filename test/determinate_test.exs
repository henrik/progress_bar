defmodule DeterminateTest do
  use ExUnit.Case

  import ExUnit.CaptureIO
  import ProgressBarAssertions

  alias ProgressBar.Utils

  # Assume a wide-enough terminal to fit a 100 column bar.
  # This needs to be explicit or tests fail when run in a narrow terminal.
  @width 200
  @format [width: @width]

  test "renders a bar" do
    assert_bar ProgressBar.render(0, 3, @format) == "|                                                                                                    |   0%"
    assert_bar ProgressBar.render(1, 3, @format) == "|=================================                                                                   |  33%"
    assert_bar ProgressBar.render(2, 3, @format) == "|===================================================================                                 |  67%"
    assert_bar ProgressBar.render(3, 3, @format) == "|====================================================================================================| 100%"
  end

  test "does not render progress above 100%" do
    assert_raise FunctionClauseError, fn ->
      ProgressBar.render(4, 3, @format)
    end
  end

  test "includes ANSI sequences to clear and re-write the line" do
    bar = capture_io(fn -> ProgressBar.render(1, 1) end)
    assert String.starts_with?(bar, "\e[2K\r")
  end

  test "scales to fit terminal width (accounting for ANSI)" do
    format = [
      left: [IO.ANSI.red, "|", IO.ANSI.reset],
      width: 20,
    ]

    actual = capture_io(fn -> ProgressBar.render(2, 3, format) end)
    actual_visible = Utils.strip_invisibles(actual)

    expected_visible = "|=========    |  67%"

    assert String.length(expected_visible) == 20
    assert actual_visible == expected_visible
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
      width: @width,
    ]
    assert_bar ProgressBar.render(2, 3, format) == "(XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.................................)"
  end

  test "custom format supports chardata lists" do
    format = [
      left: [IO.ANSI.magenta, "(", IO.ANSI.reset],
    ]

    bar = capture_io(fn -> ProgressBar.render(1, 2, format) end)
    assert bar =~ IO.chardata_to_string([IO.ANSI.magenta, "(", IO.ANSI.reset , "==="])
  end

  test "custom format falls back to defaults" do
    format = [bar: "X", right: "]", width: @width]
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

  test "suffix: :bytes" do
    mb = 1_000_000
    format = [suffix: :bytes, width: @width]
    assert_bar ProgressBar.render(0, mb, format)      == "|                                                                                                    |   0% (0.00/1.00 MB)"
    assert_bar ProgressBar.render((mb/2), mb, format) == "|==================================================                                                  |  50% (0.50/1.00 MB)"
    assert_bar ProgressBar.render(mb, mb, format)     == "|====================================================================================================| 100% (1.00 MB)"
  end

  test "suffix: :count" do
    mb = 100
    format = [suffix: :count, width: @width]
    assert_bar ProgressBar.render(0, mb, format)      == "|                                                                                                    |   0% (0/100)"
    assert_bar ProgressBar.render(50, mb, format) == "|==================================================                                                  |  50% (50/100)"
    assert_bar ProgressBar.render(mb, mb, format)     == "|====================================================================================================| 100% (100)"
  end
end
