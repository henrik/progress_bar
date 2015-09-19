# ProgressBar for Elixir

Text progress bars!

**Work in progress**, sometimes with README-driven development. May not yet do what it says below.

Do you have a use case not listed below? Please open an issue or pull request! This library is intended to be maximalist and unopinionated.


## Usage

    # Render progress from 1–100% with a 25 ms interval:
    Enum.each 1..100, fn (i) ->
      ProgressBar.render(i..100)
      :timer.sleep 25
    end

    # The progress bar works by redrawing the same output line.
    # So for any following output to end up below, we need to output a newline.
    ProgressBar.done

TODO: More examples here, including the output. Until then, see the tests and example scripts.

If you clone this repo, you can run some example scripts to see it in action:

    # See what's available.
    ls examples

    # Run an example.
    mix run examples/render.exs

### Customize format

Replace the `bar`, `blank`, `left` or `right` characters:

    format = [
      bar: "X",
      blank: ".",
      left: "(",
      right: ")",
    ]
    ProgressBar.render(97..100, format)

    # Output:

    …XXXXXXXXX...)  97%

You can provide empty-string values to e.g. remove `left` and `right` entirely.

### `percent: false`

Hides the percent shown after the bar:

    ProgressBar.render(1..1, percent: false)

    # Output:

    …============|

### `bytes: true`

This option causes the values to be treated as bytes of data, showing those amounts next to the bar:

    ProgressBar.render(2_034_237..2_097_152)

    # Output:

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

```
mix deps.get
```


## Tests

```
mix test
```


## Credits and license

By Henrik Nyh 2015-09-19 under the MIT license.
