defmodule ProgressBar.Utils do
  def strip_invisibles(string) do
    string |> String.replace(~r/\e\[\d*[a-zA-Z]|[\r\n]/, "")
  end
end
