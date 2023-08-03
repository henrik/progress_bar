defmodule EnumTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  test "it works with enums" do
    capture_io(fn ->
      list = ProgressBar.from_enum([1, 2, 3, 4, 5], fn i -> i + 1 end)

      assert list == [1, 2, 3, 4, 5]
    end)
  end

  test "it works with streams" do
    capture_io(fn ->
      list =
        [1, 2, 3, 4, 5]
        |> ProgressBar.from_stream()
        |> Enum.into([])

      assert list == [1, 2, 3, 4, 5]
    end)
  end
end
