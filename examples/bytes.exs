IO.puts "Bytes of data:"

Enum.each 0..3_000, fn (i) ->
  ProgressBar.render((i*1000), 3_000_000, bytes: true)
  :timer.sleep 1
end

ProgressBar.done
