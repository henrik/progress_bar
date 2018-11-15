defmodule UtilsTest do
  use ExUnit.Case

  test "strip_invisibles: strips ANSI" do
    input = IO.chardata_to_string([IO.ANSI.red(), "hi", IO.ANSI.reset()])
    assert ProgressBar.Utils.strip_invisibles(input) == "hi"
  end

  test "strip_invisibles: strips \r and \n" do
    assert ProgressBar.Utils.strip_invisibles("fishy\rfish\n") == "fishyfish"
  end
end
