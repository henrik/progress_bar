defmodule IndeterminateTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @ansi_prefix "\e[2K\r"

  test "renders an animated bar" do
    io = capture_io fn ->
      ProgressBar.render_indeterminate(interval: 10)
      :timer.sleep(10)
      ProgressBar.terminate
    end

    bars = io |> String.replace(@ansi_prefix, "\n") |> String.split
    [first_bar, second_bar, last_bar] = bars

    assert first_bar  == "|=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---|"
    assert second_bar  == "|-=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=---=--|"
    assert last_bar   == "|====================================================================================================|"
  end

  test "includes ANSI sequences to clear and re-write the line" do
    bars = capture_io fn ->
      ProgressBar.render_indeterminate
      ProgressBar.terminate
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
      ProgressBar.render_indeterminate(format)
      ProgressBar.terminate
    end

    # Ongoing bar.
    assert bars =~ "(=-"
    assert bars =~ "--)"

    # Finished bar.
    assert bars =~ "(XX"
    assert bars =~ "XX)"
  end
end
