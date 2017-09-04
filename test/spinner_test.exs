defmodule SpinnerTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias ProgressBar.Utils

  test "renders an animated spinner" do
    io = capture_io fn ->
      ProgressBar.render_spinner [interval: 1], fn ->
        :timer.sleep(5)
      end
    end

    assert split_frames(io) == [
      "/ Loading…",
      "- Loading…",
      "\\ Loading…",
      "| Loading…",
      "Loaded.",
    ]
  end

  test "includes ANSI sequences to clear and re-write the line" do
    io = capture_io fn ->
      ProgressBar.render_spinner fn -> :noop end
    end

    assert String.starts_with?(io, Utils.ansi_prefix)
  end

  test "custom format" do
    format = [
      frames: ["~", "-"],
      interval: 1,
      text: "Doing",
      done: "Done",
    ]

    io = capture_io fn ->
      ProgressBar.render_spinner format, fn ->
        :timer.sleep(2)
      end
    end

    assert split_frames(io) == [
      "~ Doing",
      "- Doing",
      "Done",
    ]
  end

  test "named themes" do
    format = [
      frames: :braille,
      text: "Doing",
      done: "Done",
    ]

    io = capture_io fn ->
      ProgressBar.render_spinner(format, fn -> :noop end)
    end

    assert split_frames(io) == [
      "⠋ Doing",
      "Done",
    ]
  end

  test "passes through the function's return value" do
    capture_io fn ->
      value = ProgressBar.render_spinner(fn -> :fun_return end)
      send self(), value
    end

    assert_received :fun_return
  end

  test "[done: :remove] flag" do
    io = capture_io fn ->
      ProgressBar.render_spinner([done: :remove], fn -> :noop end)
      IO.puts "after"
    end

    assert split_frames(io) == [
      "/ Loading…",
      "after",
    ]
  end

  defp split_frames(string) do
    string
    |> String.trim()
    |> String.split(Utils.ansi_prefix)
    |> Enum.reject(&(&1 == ""))
  end
end
