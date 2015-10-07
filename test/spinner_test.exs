defmodule SpinnerTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias ProgressBar.Utils

  test "renders an animated spinner" do
    io = capture_io fn ->
      ProgressBar.render_spinner [interval: 10], fn ->
        :timer.sleep(40)
      end
    end

    [frame_1, frame_2, frame_3, frame_4, frame_5] = split_frames(io)

    assert frame_1  == "/ Loading…"
    assert frame_2  == "- Loading…"
    assert frame_3  == "\\ Loading…"
    assert frame_4  == "| Loading…"
    assert frame_5  == "Loaded."
  end

  test "includes ANSI sequences to clear and re-write the line" do
    io = capture_io fn ->
      ProgressBar.render_spinner fn -> end
    end

    assert String.starts_with?(io, Utils.ansi_prefix)
  end

  test "custom format" do
    format = [
      frames: ["A", "B"],
      text: "Fooing",
      done: "Fooed",
    ]

    io = capture_io fn ->
      ProgressBar.render_spinner(format, fn -> end)
    end

    [frame_1, frame_2] = split_frames(io)

    assert frame_1 == "A Fooing"
    assert frame_2 == "Fooed"
  end

  test "passes through the function's return value" do
    capture_io fn ->
      value = ProgressBar.render_spinner(fn -> :fun_return end)
      send self, value
    end

    assert_received :fun_return
  end

  defp split_frames(string) do
    string
    |> String.strip
    |> String.split(Utils.ansi_prefix)
    |> Enum.reject(&(&1 == ""))
  end
end
