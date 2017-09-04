defmodule BytesTest do
  @mb 1_000_000
  @kb 1_000

  use ExUnit.Case

  test "format/1: formats one value with unit" do
    assert ProgressBar.Bytes.format(kb_to_bytes(1.23)) == "1.23 KB"
  end

  test "format/1: converts to KB for values below 1 MB" do
    assert ProgressBar.Bytes.format(0) == "0.00 KB"
    assert ProgressBar.Bytes.format(kb_to_bytes(0.01)) == "0.01 KB"
    assert ProgressBar.Bytes.format(kb_to_bytes(1.23)) == "1.23 KB"
    assert ProgressBar.Bytes.format(@mb - 1) == "999.99 KB"
  end

  test "format/1: converts to MB for values of 1 MB or higher" do
    assert ProgressBar.Bytes.format(@mb) == "1.00 MB"
    assert ProgressBar.Bytes.format(mb_to_bytes(1.23)) == "1.23 MB"
  end

  test "format/1: always uses two decimals" do
    assert ProgressBar.Bytes.format(mb_to_bytes(1.2)) == "1.20 MB"
  end

  test "format/2: formats two values, with the unit mentioned once" do
    assert ProgressBar.Bytes.format(mb_to_bytes(1.2), mb_to_bytes(2.0)) == "1.20/2.00 MB"
  end

  test "format/2: converts to KB if total_bytes is below 1 MB" do
    assert ProgressBar.Bytes.format(kb_to_bytes(0.1), @mb - 1) == "0.10/999.99 KB"
  end

  test "format/2: converts to MB if total_bytes is 1 MB or higher" do
    assert ProgressBar.Bytes.format(1, @mb) == "0.00/1.00 MB"
    assert ProgressBar.Bytes.format(@mb - 1, @mb) == "0.99/1.00 MB"
  end

  defp mb_to_bytes(mb) do
    trunc(mb * @mb)
  end

  defp kb_to_bytes(kb) do
    trunc(kb * @kb)
  end
end
