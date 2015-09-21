# ProgressBar for Elixir

Do you have a use case not listed below? Please open an issue or pull request!


## Examples

To see it in action, clone this repo and run the example scripts:

    # Run all examples.
    mix run examples/all.exs

    # See what's available.
    ls examples

    # Run a single example.
    mix run examples/default.exs


## Usage

You can render regular ("determinate") progress bars, or "indeterminate" ones that animate but don't indicate the current progress.

### Determinate progress bars

Specify the current value and the total value, and a bar will be rendered to STDOUT.

``` elixir
ProgressBar.render(2, 3)
```

Output:

    |===================================================================                                 |  67%

Call the function again and it will overwrite the previous bar with the new value:

``` elixir
ProgressBar.render(2, 3)
ProgressBar.render(3, 3)
```

Output:

    |====================================================================================================| 100%

This basically works by printing "\r[===…" each time, without a newline. The text cursor will return to the beginning of the line and overwrite the previous value.

When the bar becomes full, a newline is automatically printed, so any subsequent output gets its own line.

It's up to you to re-render the bar when something changes. Here's a trivial example of an animated progress bar:

``` elixir
Enum.each 1..100, fn (i) ->
  ProgressBar.render(i, 100)
  :timer.sleep 25
end
```

#### Customize format

Replace the `bar`, `blank`, `left` or `right` characters.

``` elixir
format = [
  bar: "X",   # default: "="
  blank: ".", # default: " "
  left: "(",  # default: "|"
  right: ")", # default: "|"
]

ProgressBar.render(97, 100, format)
```

Output:

    …XXXXXXXXX...)  97%

You can provide empty-string values to remove `left` and `right` entirely.

#### Customize color

Specify [IO.ANSI values](http://elixir-lang.org/docs/v1.0/elixir/IO.ANSI.html) as `bar_color` or `blank_color`. Use lists for multiple values.

``` elixir
format = [
  bar_color: [IO.ANSI.white, IO.ANSI.green_background],
  blank_color: IO.ANSI.red_background,
]

ProgressBar.render(97, 100, format)
```

#### `percent: false`

Hides the percentage shown after the bar.

``` elixir
ProgressBar.render(1, 1, percent: false)
```

Output:

    …============|

Instead of:

    …============| 100%

#### `bytes: true`

This option causes the values to be treated as bytes of data, showing those amounts next to the bar.

``` elixir
ProgressBar.render(2_034_237, 2_097_152, bytes: true)
```

Output:

    …=========   |  97% (1.94/2.0 MB)

### Indeterminate progress bars

Indeterminate progress bars will animate on their own, once you start them off. It's up to you to terminate them when done.

Don't output anything else while this bar is animating, as it will keep rewriting the current output line.

``` elixir
# Start it.
ProgressBar.render_indeterminate

# Do something for an indeterminate amount of time…
:timer.sleep 2000

# Show the progress bar as done.
ProgressBar.terminate
```

It will alternate between four forms by default:

    |=---=---=---=---=---=---=---=---=---=---=---…
    |-=---=---=---=---=---=---=---=---=---=---=--…
    |--=---=---=---=---=---=---=---=---=---=---=-…
    |---=---=---=---=---=---=---=---=---=---=---=…

And show as done when you terminate it:

    |==========================================…

#### Customize format

You can customize the forms it alternates between, as well as the done state, and the `left` and `right` bookends.

``` elixir
ProgressBar.render_indeterminate(
  bars: [ "Oo", "oO" ],
  done: "X",
  left: "",
  right: "",
)
```

The `bars` list can be any length – the bar will alternate between them and then start over.

Each string in that list can be any length by which 100 is evenly divisible (e.g. 1, 2, 4, 5, 10…), and will repeat into a 100 character bar.

#### Customize color

You can customize the color of the bar, and of the completed state.

``` elixir
ProgressBar.render_indeterminate(
  bars_color: IO.ANSI.yellow,
  done_color: IO.ANSI.green,
)
```

You can pass multiple `IO.ANSI` values, just as with a regular progress bar. The indeterminate bar intentionally doesn't alternate between colors, so as not to trigger epileptic seizures…

#### Interval

You can customize the millisecond interval at which it alternates. The default is 500 milliseconds.

``` elixir
ProgressBar.render_indeterminate(interval: 10)
```


## Installation

Add the dependency to your project's `mix.exs`:

``` elixir
defp deps do
  [
    {:progress_bar, "> 0.0.0"},
  ]
end
```

Then fetch it:

    mix deps.get


## Tests

    mix test


## Credits and license

By Henrik Nyh 2015-09-19 under the MIT license.
