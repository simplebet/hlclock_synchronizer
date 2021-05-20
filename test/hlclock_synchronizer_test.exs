defmodule HLClockSynchronizerTest do
  use ExUnit.Case
  doctest HLClockSynchronizer

  test "publishes timestamp syncs on an interval" do
    start_supervised!({Phoenix.PubSub, name: Test.PubSub})
    start_supervised!({HLClock, name: Test.Clock})

    Phoenix.PubSub.subscribe(Test.PubSub, "hlclock")

    start_supervised!(
      {HLClockSynchronizer,
       [interval: 1, name: :hlclocktest, pubsub: Test.PubSub, clock: Test.Clock]}
    )

    assert_receive {:sync, ts1}, 1_000, "Failed to receive initialization sync message"
    assert_receive {:sync, ts2}, 2_000, "Failed to receive interval sync message"

    assert HLClock.before?(ts1, ts2)
  end
end
