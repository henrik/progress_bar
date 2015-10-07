IO.puts ""
IO.puts "Spinner:"

format = [
  frames: :braille,
  interval: 100,
  spinner_color: IO.ANSI.magenta,
  text: "Spinning just for you…",
  done: [IO.ANSI.green, "✓", IO.ANSI.reset, " Done spinning."],
]

ProgressBar.render_spinner(format, fn -> :timer.sleep 5000 end)
