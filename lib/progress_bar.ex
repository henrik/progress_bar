defmodule ProgressBar do
  def render(current, total) do
    ProgressBar.Determinate.render(current, total)
  end

  def render(current, total, custom_format) do
    ProgressBar.Determinate.render(current, total, custom_format)
  end

  def render_indeterminate(fun) do
    ProgressBar.Indeterminate.render(fun)
  end

  def render_indeterminate(custom_format, fun) do
    ProgressBar.Indeterminate.render(custom_format, fun)
  end

  def render_spinner(fun) do
    ProgressBar.Spinner.render(fun)
  end

  def render_spinner(custom_format, fun) do
    ProgressBar.Spinner.render(custom_format, fun)
  end

  def from_enum(list, fun, opts \\ []) do
    total = Enum.count(list)

    ProgressBar.render(0, total, opts)

    list
    |> Enum.with_index(1)
    |> Enum.each(fn {el, i} ->
      fun.(el)
      ProgressBar.render(i, total, opts)
    end)

    list
  end

  def from_stream(list, opts \\ []) do
    total = Enum.count(list)

    ProgressBar.render(0, total, opts)

    list
    |> Stream.with_index(1)
    |> Stream.map(fn {el, i} ->
      ProgressBar.render(i, total, opts)
      el
    end)
  end
end
