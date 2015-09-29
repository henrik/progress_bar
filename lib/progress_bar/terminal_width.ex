defmodule ProgressBar.TerminalWidth do
  @fallback 80

  def determine do
    if System.find_executable("tput") do
      {num_string, 0} = System.cmd("tput", ["cols"])
      {num, _} = Integer.parse(num_string)
      num
    else
      @fallback
    end
  end
end
