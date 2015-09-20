defmodule ProgressBar.IndeterminateServer do
  use GenServer

  @width 100

  # Client API

  def start(format) do
    GenServer.start(__MODULE__, {format, true}, name: :indeterminate)
  end

  def stop do
    GenServer.call(:indeterminate, :stop)
  end

  # GenServer API

  def init(state = {format, flip}) do
    tick(state)

    {:ok, {format, !flip}}
  end

  def handle_info(:tick, state = {format, flip}) do
    tick(state)

    {:noreply, {format, !flip}}
  end

  def handle_call(:stop, _from, {format, interval}) do
    render_done(format)

    {:stop, :normal, :ok, {format, interval}}
  end

  # Private

  defp tick({format, flip}) do
    render_bar(format, flip)

    interval = format[:interval]
    Process.send_after(self, :tick, interval)
  end

  defp render_bar(format, flip) do
    [part1, part2] = format[:bars]
    part = if flip, do: repeat(part1), else: repeat(part2)
    bar = part |> repeat |> color(format[:bars_color])
    ProgressBar.Formatter.write(format, bar)
  end

  defp render_done(format) do
    bar = format[:done] |> repeat |> color(format[:done_color])
    ProgressBar.Formatter.write(format, bar, "\n")
  end

  defp repeat(bar) do
    String.duplicate(bar, trunc(@width/String.length(bar)))
  end

  defp color(content, []), do: content
  defp color(content, ansi_codes) do
    [ ansi_codes, content, IO.ANSI.reset ]
  end
end
