IO.puts "Custom format:"

format = [
  bar: "X",
  blank: ".",
  left: "[",
  right: "]",
]

Enum.each 1..100, fn (i) ->
  ProgressBar.render(i, 100, format)
  :timer.sleep 30
end

ProgressBar.done
