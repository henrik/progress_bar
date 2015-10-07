IO.puts ""
IO.puts "Spinner:"

format = [
  frames: :strokes,
  spinner_color: IO.ANSI.magenta,
  text: "Spinning just for you…",
  done: [IO.ANSI.green, "✓", IO.ANSI.reset, " Done spinning."],
]

ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)

format = Keyword.merge(format, [frames: :braille])
ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)

format = Keyword.merge(format, [frames: :bars])
ProgressBar.render_spinner(format, fn -> :timer.sleep 3000 end)
