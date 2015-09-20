IO.puts "Indeterminate bar (with custom values):"

format = [
  bars: ["oO", "Oo"],
  done: "!",
  bars_color: IO.ANSI.yellow,
  done_color: IO.ANSI.green,
]

ProgressBar.render_indeterminate(format)
:timer.sleep 4000
ProgressBar.terminate

IO.puts "All done!"
