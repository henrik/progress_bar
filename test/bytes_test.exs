defmodule BytesTest do
  @mb 1_048_576

  use ExUnit.Case

  test "format/1: converts to MB" do
    bytes = @mb * 1.23 |> trunc
    assert ProgressBar.Bytes.format(bytes) == "1.23 MB"
  end

  test "format/1: always uses two decimals" do
    bytes = @mb * 1.20 |> trunc
    assert ProgressBar.Bytes.format(bytes) == "1.20 MB"
  end

  test "format/2: shows two values" do
    current_bytes = @mb * 1.20 |> trunc
    total_bytes = @mb * 2 |> trunc
    assert ProgressBar.Bytes.format(current_bytes, total_bytes) == "1.20/2.00 MB"
  end
end
