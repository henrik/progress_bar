files_in_dir = File.ls!(__DIR__)
this_file = Path.basename(__ENV__.file)
example_files = List.delete(files_in_dir, this_file)

Enum.each example_files, fn (file) ->
  Code.eval_file(__DIR__ <> "/" <> file)
  IO.puts ""
end
