defmodule ProgressBar do
  def render(current..total, custom_format \\ default_format) do
    format = Keyword.merge(default_format, custom_format)

    bar = String.duplicate(format[:bar], current)
    blank = String.duplicate(format[:blank], total - current)

    formatted_percent = if format[:percent] do
      number = current / total * 100 |> Float.round |> trunc |> Integer.to_string
      " " <> String.rjust(number, 3) <> "%"
    else
      ""
    end

    IO.write "\r#{format[:left]}#{bar}#{blank}#{format[:right]}#{formatted_percent}"
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
      percent: true,
    ]
  end
end
