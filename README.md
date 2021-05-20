# HLClockSynchronizer

A GenServer that syncs [HLClock](https://hexdocs.pm/hlclock/HLClock.html) timestamps between nodes using [Phoenix.Pubsub](https://hexdocs.pm/phoenix_pubsub/Phoenix.PubSub.html).

Note that in order for this to work, you must cluster your nodes using something like [libcluster](https://hexdocs.pm/libcluster/readme.html) and for PubSub to be running in distribute mode.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `hlcid_synchronizer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hlclock_synchronizer, "~> 0.1.0"}
  ]
end
```

## Usage
```
# In your supervision tree, add this as a child spec
# Note that you can use any HLClock clock, here I use HLCID.Clock

{HLClockSynchronizer, pubsub: MyApp.PubSub, clock: HLCID.Clock}
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/hlcid_synchronizer](https://hexdocs.pm/hlcid_synchronizer).

