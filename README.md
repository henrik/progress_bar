# ProgressBar for Elixir

Text progress bars!

**Work in progress** with README-driven development. May not yet do what it says below.

Inspired by Jeff Felchner's [ruby-progressbar](https://github.com/jfelchner/ruby-progressbar/wiki/Basic-Usage).

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

If you clone this repo, you can run some example scripts to see it in action:

    # See what's available.
    ls examples

    # Run an example.
    mix run examples/render.exs


## Installation

Add the dependency to your project's `mix.exs`:

``` elixir
defp deps do
  [
    {:progress_bar},
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


## License

By Henrik Nyh 2015-09-19 under the MIT license.
