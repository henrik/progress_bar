defmodule EnumTest do
  use ExUnit.Case

  alias ProgressBar.Utils
  import ExUnit.CaptureIO

  test "it works with enums" do
    test_pid = self()

    io =
      capture_io(fn ->
        list = ProgressBar.from_enum([1, 2, 3, 4, 5], fn _ -> send(test_pid, :fn_run) end)

        assert list == [1, 2, 3, 4, 5]
      end)

    assert split_bars(io) == [
             "|",
             "|",
             "0%",
             "|===============",
             "|",
             "20%",
             "|=============================",
             "|",
             "40%",
             "|============================================",
             "|",
             "60%",
             "|==========================================================",
             "|",
             "80%",
             "|=========================================================================|",
             "100%"
           ]

    for _ <- 1..5, do: assert_received(:fn_run)
    refute_received :fn_run
  end

  test "it works with streams" do
    io =
      capture_io(fn ->
        list =
          [1, 2, 3, 4, 5]
          |> ProgressBar.from_stream()
          |> Enum.into([])

        assert list == [1, 2, 3, 4, 5]
      end)

    assert split_bars(io) == [
             "|",
             "|",
             "0%",
             "|===============",
             "|",
             "20%",
             "|=============================",
             "|",
             "40%",
             "|============================================",
             "|",
             "60%",
             "|==========================================================",
             "|",
             "80%",
             "|=========================================================================|",
             "100%"
           ]
  end

  defp split_bars(string) do
    string |> String.replace(Utils.ansi_prefix(), "\n") |> String.split()
  end
end
