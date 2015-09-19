defmodule ProgressBar do
  def render(current..total, custom_format \\ default_format) do
    format = Keyword.merge(default_format, custom_format)

    bar = String.duplicate(format[:bar], current)
    blank = String.duplicate(format[:blank], total - current)

    IO.write "\r#{format[:left]}#{bar}#{blank}#{format[:right]}"
  end

  def done do
    IO.write "\n"
  end

  defp default_format do
    [
      bar: "=",
      blank: " ",
      left: "|",
      right: "|",
    ]
  end
end
