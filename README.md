# ProgressBar for Elixir

Text progress bars!

Do you have a use case not listed below? Please open an issue or pull request! This library is intended to be maximalist and unopinionated.


## Usage

Specify the current value and the total value, and a bar will be rendered to STDOUT:

``` elixir
ProgressBar.render(2, 3)
```

Output:

    [===================================================================                                 |  67%

Call the function again and it will overwrite the previous bar with the new value:

``` elixir
ProgressBar.render(2, 3)
ProgressBar.render(3, 3)
```

Output:

    [====================================================================================================| 100%

This basically works by printing "\r[===…" each time, without a newline. The text cursor will return to the beginning of the line and overwrite the previous value.

When the bar becomes full, a newline is automatically printed, so any subsequent output gets its own line.

It's up to you to re-render the bar when something changes. Here's a trivial example of an animated progress bar:

``` elixir
Enum.each 1, 100, fn (i) ->
  ProgressBar.render(i, 100)
  :timer.sleep 25
end
```

To see it in action, clone this repo and run the example scripts:

    # See what's available.
    ls examples

    # Run an example.
    mix run examples/default.exs

### Customize format

Replace the `bar`, `blank`, `left` or `right` characters:

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

You can provide empty-string values to e.g. remove `left` and `right` entirely.

### `percent: false`

Hides the percent shown after the bar:

``` elixir
ProgressBar.render(1, 1, percent: false)
```

Output:

    …============|

### `bytes: true`

This option causes the values to be treated as bytes of data, showing those amounts next to the bar:

``` elixir
ProgressBar.render(2_034_237, 2_097_152)
```

Output:

    …=========   |  97% (1.94/2.0 MB)


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
