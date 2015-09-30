defmodule IndeterminateTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias ProgressBar.Utils

  # Assume a wide-enough terminal to fit a 100 column bar.
  # This needs to be explicit or tests fail when run in a narrow terminal.
  @width 200

  @ansi_prefix "\e[2K\r"

  test "renders an animated bar" do
    io = capture_io fn ->
      ProgressBar.render_indeterminate [interval: 10, width: @width], fn ->
        :timer.sleep(10)
      end
    end

    [first_bar, second_bar, last_bar] = split_bars(io)

    assert first_bar  == "|=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---|"
    assert second_bar  == "|-=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=--|"
    assert last_bar   == "|====================================================================================================|"
  end

  test "includes ANSI sequences to clear and re-write the line" do
    bars = capture_io fn ->
      ProgressBar.render_indeterminate fn -> end
    end

    assert String.starts_with?(bars, @ansi_prefix)
  end

  test "scales to fit terminal width (accounting for ANSI)" do
    format = [
      left: [IO.ANSI.red, "|", IO.ANSI.reset],
      width: 20,
    ]

    actual =
      capture_io(fn -> ProgressBar.render_indeterminate(format, fn -> end) end)
      |> first_bar

    actual_visible = Utils.strip_invisibles(actual)

    expected_visible = "|=---=---=---=---=-|"

    assert String.length(expected_visible) == 20
    assert actual_visible == expected_visible
  end

  test "custom format" do
    format = [
      left: "(",
      right: ")",
      done: "X",
    ]

    bars = capture_io fn ->
      ProgressBar.render_indeterminate(format, fn -> end)
    end

    # Ongoing bar.
    assert bars =~ "(=-"
    assert bars =~ "--)"

    # Finished bar.
    assert bars =~ "(XX"
    assert bars =~ "XX)"
  end

  test "handles custom bars that don't go evenly into the bar width" do
    format = [
      bars: ["123"],
      width: @width,
    ]

    bars = capture_io fn ->
      ProgressBar.render_indeterminate(format, fn -> end)
    end

    expected_bar = String.duplicate("123", 33) <> "1"  # "123…1231"
    assert bars =~ "|#{expected_bar}|"
  end

  test "passes through the function's return value" do
    capture_io fn ->
      value = ProgressBar.render_indeterminate(fn -> :fun_return end)
      send self, value
    end

    assert_received :fun_return
  end

  defp first_bar(string) do
    string |> split_bars |> hd
  end

  defp split_bars(string) do
    string |> String.replace(@ansi_prefix, "\n") |> String.split
  end
end
