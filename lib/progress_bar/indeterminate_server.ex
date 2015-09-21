defmodule ProgressBar.IndeterminateServer do
  use GenServer

  @width 100

  # Client API

  def start(format) do
    GenServer.start(__MODULE__, {format, 0}, name: :indeterminate)
  end

  def stop do
    GenServer.call(:indeterminate, :stop)
  end

  # GenServer API

  def init(state = {format, count}) do
    tick(state)
    {:ok, {format, count + 1}}
  end

  def handle_info(:tick, state = {format, count}) do
    tick(state)
    {:noreply, {format, count + 1}}
  end

  def handle_call(:stop, _from, {format, count}) do
    render_done(format)
    {:stop, :normal, :ok, {format, count}}
  end

  # Private

  defp tick({format, count}) do
    render_bar(format, count)

    interval = format[:interval]
    Process.send_after(self, :tick, interval)
  end

  defp render_bar(format, count) do
    parts = format[:bars]
    index = rem(count, length(parts))

    part = Enum.at(parts, index)

    bar = part |> repeat |> color(format[:bars_color])
    ProgressBar.Formatter.write(format, bar)
  end

  defp render_done(format) do
    bar = format[:done] |> repeat |> color(format[:done_color])
    ProgressBar.Formatter.write(format, bar, "\n")
  end

  defp repeat(bar) do
    repetitions = @width/String.length(bar) |> Float.ceil |> trunc
    String.duplicate(bar, repetitions) |> String.slice(0, @width)
  end

  defp color(content, []), do: content
  defp color(content, ansi_codes) do
    [ ansi_codes, content, IO.ANSI.reset ]
  end
end
