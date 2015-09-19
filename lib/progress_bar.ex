defmodule ProgressBar do
  def render(current..total) do
    bar = String.duplicate("=", current)
    blank = String.duplicate(" ", total - current)
    IO.write "\r|#{bar}#{blank}|"
  end

  def done do
    IO.write "\n"
  end
end
