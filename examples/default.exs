IO.puts "Default bar:"

Enum.each 1..100, fn (i) ->
  ProgressBar.render(i, 100)
  :timer.sleep 30
end

IO.puts "All done!"
