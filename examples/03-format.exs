IO.puts ""
IO.puts "Custom format:"

format = [
  bar: "=~",
  blank: ". ",
  left: [IO.ANSI.green, "[", IO.ANSI.reset],
  right: [IO.ANSI.red, "]", IO.ANSI.reset],
]

Enum.each 1..100, fn (i) ->
  ProgressBar.render(i, 100, format)
  :timer.sleep 30
end
