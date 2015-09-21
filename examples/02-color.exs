IO.puts ""
IO.puts "Custom color:"

format = [
  bar_color: [IO.ANSI.green_background],
  blank_color: [IO.ANSI.red_background],
  bar: " ",
  blank: " ",
  left: " ", right: " ",
]

Enum.each 1..100, fn (i) ->
  ProgressBar.render(i, 100, format)
  :timer.sleep 30
end
