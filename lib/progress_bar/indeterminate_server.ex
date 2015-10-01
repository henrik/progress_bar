defmodule ProgressBar.IndeterminateServer do
  use GenServer

  # Client API

  def start(format) do
    GenServer.start(__MODULE__, {format, 0}, name: :indeterminate)
  end

  def stop do
    GenServer.call(:indeterminate, :stop)
  end

  # GenServer API

  def init(state) do
    {:ok, tick(state)}
  end

  def handle_info(:tick, state) do
    {:noreply, tick(state)}
  end

  def handle_call(:stop, _from, {format, count}) do
    render_done(format)
    {:stop, :normal, :ok, {format, count}}
  end

  # Private

  defp tick({format, count}) do
    render_bar(format, count)

    # This timer is automatically cancelled when the server goes away.
    Process.send_after(self, :tick, format[:interval])

    {format, count + 1}
  end

  defp render_bar(format, count) do
    parts = format[:bars]
    index = rem(count, length(parts))
    part = Enum.at(parts, index)

    ProgressBar.Formatter.write(
      format,
      {part, format[:bars_color]},
      ""
    )
  end

  defp render_done(format) do
    ProgressBar.Formatter.write(
      format,
      {format[:done], format[:done_color]},
      "\n"
    )
  end
end
