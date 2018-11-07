ExUnit.start()

defmodule ProgressBarAssertions do
  defmacro assert_bar({:==, _, [rendering, expected]}) do
    actual =
      quote do
        ExUnit.CaptureIO.capture_io(fn -> unquote(rendering) end)
        |> String.replace(~r/^\e\[2K\r/, "")
        |> String.replace(~r/\n$/, "")
      end

    quote do
      assert unquote(actual) == unquote(expected)
    end
  end
end
