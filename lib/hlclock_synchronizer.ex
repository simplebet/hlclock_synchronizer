defmodule HLClockSynchronizer do
  @moduledoc """
  Handles synchronization of the `HLClock` timestamps.
  Periodic sync of timestamps between nodes helps to ensure one-way
  causality determination across the system.
  """
  use GenServer

  @topic "hlclock"

  @doc "Send a synchronization message to the cluster"
  def sync(pubsub, clock) do
    {:ok, ts} = HLClock.now(clock)
    Phoenix.PubSub.broadcast_from(pubsub, self(), @topic, {:sync, ts})
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts[:name] || __MODULE__)
  end

  def init(opts) do
    pubsub = Keyword.fetch!(opts, :pubsub)
    clock = Keyword.fetch!(opts, :clock)

    state = %{interval: opts[:interval] || :timer.seconds(30), pubsub: pubsub, clock: clock}

    {:ok, state, {:continue, :pubsub_subscribe}}
  end

  def handle_continue(:pubsub_subscribe, state) do
    Phoenix.PubSub.subscribe(state.pubsub, @topic)
    {:noreply, state, {:continue, :setup_sync}}
  end

  def handle_continue(:setup_sync, state) do
    sync(state.pubsub, state.clock)
    schedule_sync(state.interval)

    {:noreply, state}
  end

  defp schedule_sync(interval) do
    :timer.send_after(interval, :send_sync)
  end

  def handle_info({:sync, remote_ts}, state) do
    HLClock.recv_timestamp(state.clock, remote_ts)
    {:noreply, state}
  end

  def handle_info(:send_sync, state) do
    sync(state.pubsub, state.clock)
    {:noreply, state}
  end
end
