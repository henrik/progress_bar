IO.puts "Rendering progress with an interval:"

Enum.each 1..100, fn (i) ->
  ProgressBar.render(i..100)
  :timer.sleep 30
end

# The progress bar works by redrawing the same output line.
# So for any following output to end up below, we need to output a newline.
ProgressBar.done

IO.puts "All done!"
