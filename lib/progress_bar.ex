defmodule ProgressBar do
  def render(current, total) do
    ProgressBar.Determinate.render(current, total)
  end
  def render(current, total, custom_format) do
    ProgressBar.Determinate.render(current, total, custom_format)
  end

  def render_indeterminate do
    ProgressBar.Indeterminate.render
  end
  def render_indeterminate(custom_format) do
    ProgressBar.Indeterminate.render(custom_format)
  end

  def terminate do
    ProgressBar.Indeterminate.terminate
  end
end
