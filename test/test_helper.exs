ExUnit.start()

defmodule ProgressBarAssertions do
  defmacro assert_bar({:==, _, [rendering, expected]}) do
    captured_io = quote do
      ExUnit.CaptureIO.capture_io(fn -> unquote(rendering) end)
    end

    expected_with_ansi = "\e[2K\r" <> expected

    quote do
      assert unquote(captured_io) == unquote(expected_with_ansi)
    end
  end
end
