defmodule IndeterminateTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @ansi_prefix "\e[2K\r"

  test "renders an animated bar" do
    io = capture_io fn ->
      ProgressBar.render_indeterminate [interval: 10], fn ->
        :timer.sleep(10)
      end
    end

    bars = io |> String.replace(@ansi_prefix, "\n") |> String.split
    [first_bar, second_bar, last_bar] = bars

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

  test "handles custom bars that don't go evenly into the 100 bar width" do
    format = [
      bars: ["123"],
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
end
