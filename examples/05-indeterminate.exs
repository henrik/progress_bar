IO.puts ""
IO.puts "Indeterminate bar (with custom colors):"

format = [
  bars_color: IO.ANSI.yellow,
  done_color: IO.ANSI.green,
]

ProgressBar.render_indeterminate(format, fn -> :timer.sleep 5000 end)
