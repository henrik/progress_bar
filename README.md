# ProgressBar for Elixir

[![Build Status](https://travis-ci.org/henrik/progress_bar.svg?branch=master)](https://travis-ci.org/henrik/progress_bar)
[![Module Version](https://img.shields.io/hexpm/v/progress_bar.svg)](https://hex.pm/packages/progress_bar)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/progress_bar/)
[![Total Download](https://img.shields.io/hexpm/dt/progress_bar.svg)](https://hex.pm/packages/progress_bar)
[![License](https://img.shields.io/hexpm/l/progress_bar.svg)](https://github.com/henrik/progress_bar/blob/master/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/henrik/progress_bar.svg)](https://github.com/henrik/progress_bar/commits/master)

Command-line progress bars and spinners.

![Screenshot](https://s3.amazonaws.com/f.cl.ly/items/2N3n440S0d2S2n371j0G/progress_bar.gif)

* [Usage](#usage)
* [Examples](#examples)
* [Installation](#installation)
* [License](#license)


## Usage

You can render:
  * [progress bars](#progress-bars),
  * [indeterminate bars](#indeterminate-progress-bars) that animate but don't
    indicate the current progress,
  * and [indeterminate spinners](#spinners).

Do you have a use case not listed below? Please open an issue or pull request!


### Progress bars

Specify the current value and the total value, and a bar will be rendered to STDOUT.

``` elixir
ProgressBar.render(2, 3)
```

Output:

    |==================================                |  67%

Call the function again and it will overwrite the previous bar with the new value:

``` elixir
ProgressBar.render(2, 3)
ProgressBar.render(3, 3)
```

Output:

    |==================================================| 100%

This basically works by printing "\r[===…" each time, without a newline. The text cursor will return to the beginning of the line and overwrite the previous value.

When the bar becomes full, a newline is automatically printed, so any subsequent output gets its own line.

It's up to you to re-render the bar when something changes. Here's a trivial example of an animated progress bar:

``` elixir
Enum.each 1..100, fn (i) ->
  ProgressBar.render(i, 100)
  :timer.sleep 25
end
```

#### Width

The bar will automatically set its width to fit the terminal. If the terminal width can't be determined automatically, an 80 column width will be assumed.

If you really want to, you may specify an explicit terminal column width to fit inside:

``` elixir
ProgressBar.render(97, 100, width: 30)
```

Even with a wide terminal, note that the bar proper maxes out at 100 characters wide (one per percentage point) and will not go wider.

#### Customize format

Replace the `bar`, `blank`, `left` or `right` values.

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

`bar` and `blank` don't have to be single characters. They can be any-length strings and will repeat and truncate as appropriate.

You can provide empty-string values to remove `left` and `right` entirely.

You can also provide `left` or `right` as chardata lists with [IO.ANSI values](http://elixir-lang.org/docs/v1.0/elixir/IO.ANSI.html):

``` elixir
format = [
  left: [IO.ANSI.magenta, "PROGRESS:", IO.ANSI.reset, " |"],
]
```

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

#### `suffix: :count`

This option causes the values to be printed on the suffix of your progress bar.

``` elixir
ProgressBar.render(9_751, 10_000, suffix: :count)
```

Output:

    …=========   |  97% (9751/10000)


#### `suffix: :bytes`

This option causes the values to be treated as bytes of data, showing those amounts next to the bar.

``` elixir
ProgressBar.render(2_034_237, 2_097_152, suffix: :bytes)
```

Output:

    …=========   |  97% (1.94/2.00 MB)

The unit (KB or MB) is determined automatically.

This is great with [progressive downloads](https://gist.github.com/henrik/108e5fc23b66131fc3aa).


### Indeterminate progress bars

Indeterminate progress bars will animate on their own for the duration of a function you pass to it.

``` elixir
ProgressBar.render_indeterminate fn ->
  # Do something for an indeterminate amount of time…
  :timer.sleep 2000
end
```

It will alternate between four forms by default:

    |=---=---=---=---=---=---=---=---=---=---=---…
    |-=---=---=---=---=---=---=---=---=---=---=--…
    |--=---=---=---=---=---=---=---=---=---=---=-…
    |---=---=---=---=---=---=---=---=---=---=---=…

And then show as done:

    |============================================…

The return value of the function is passed through, if you want it:

``` elixir
data = ProgressBar.render_indeterminate fn ->
  ApiClient.painstakingly_retrieve_data
end

IO.puts "Finally got the data: #{inspect data}"
```

#### Customize format

You can customize the forms it alternates between, as well as the done state, and the `left` and `right` bookends.

``` elixir
ProgressBar.render_indeterminate [
  bars: [ "Oo", "oO" ],
  done: "X",
  left: "",
  right: "",
], fn -> end
```

The `bars` list can be any length. Each string in that list is a "frame" in the animation. The bar will alternate between these strings, and then start over.

Each string in the list can be any length and will repeat to fit the bar.


#### Customize color

You can customize the color of the bar, and of the completed state.

``` elixir
ProgressBar.render_indeterminate [
  bars_color: IO.ANSI.yellow,
  done_color: IO.ANSI.green,
], fn -> end
```

You can pass multiple `IO.ANSI` values, just as with a regular progress bar. The indeterminate bar intentionally doesn't alternate between colors, so as not to trigger epileptic seizures…

#### Interval

You can customize the millisecond interval at which it alternates. The default is 500 milliseconds.

``` elixir
ProgressBar.render_indeterminate([interval: 10], fn -> end)
```


### Spinners

A spinner is similar to an indeterminate progress bar. But instead of a bar, it shows a "spinning" animation next to some text.

``` elixir
ProgressBar.render_spinner [text: "Loading…", done: "Loaded."], fn ->
  # Do something for an indeterminate amount of time…
  :timer.sleep 2000
end
```

This is the default animation and text:

    / Loading…
    - Loading…
    \ Loading…
    | Loading…

Then it shows as done:

    Loaded.

You can customize some things:

``` elixir
format = [
  frames: ["/" , "-", "\\", "|"],  # Or an atom, see below
  text: "Loading…",
  done: "Loaded.",
  spinner_color: IO.ANSI.magenta,
  interval: 100,  # milliseconds between frames
]

ProgressBar.render_spinner format, my_function
```

Colors can be lists just like with other progress bars.

If you want the done state to also be some colored symbol, just use chardata lists:

``` elixir
format = [
  done: [IO.ANSI.green, "✓", IO.ANSI.reset, " Loaded."],
]
```

Or you can pass `done: :remove` to stop showing this line of text entirely when it completes.

As with indeterminate progress bars, the return value of the function is passed through if you want it:

``` elixir
data = ProgressBar.render_spinner fn ->
  ApiClient.painstakingly_retrieve_data
end

IO.puts "Finally got the data: #{inspect data}"
```

#### Predefined spinners

Instead of specifying the frames as a list, you can assign one of the predefined styles as an atom:

``` elixir
ProgressBar.render_spinner([frames: :braille], fn -> end)
```

Name                 | Frames
-------------------- | ---------------------------
`:strokes` (default) | `/ - \ \|`
`:braille`           | `⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏`
`:bars`              | `▁ ▂ ▃ ▄ ▅ ▆ ▇ █ ▇ ▆ ▅ ▄ ▃`


## Examples

To see these bad boys in action, clone this repo and run the example scripts:

    # Run all examples.
    mix run examples/all.exs

    # See what's available.
    ls examples

    # Run a single example.
    mix run examples/02-color.exs

Or to see them in a real project, try [Sipper](https://github.com/henrik/sipper).


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


## See Also

* [simple_bar](https://github.com/jeffreybaird/simple_bar)


## License

Released under [the MIT License](./LICENSE.md).
