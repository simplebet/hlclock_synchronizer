defmodule HLClockSynchronizer.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :hlclock_synchronizer,
      version: @version,
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: :hlclock_syncrhonizer,
      package: package(),
      description: description(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:hlclock, "~> 1.0"},
      {:phoenix_pubsub, "~> 2.0"}
    ]
  end

  defp description do
    """
    A GenServer that syncs HLClock timestamps between nodes using Phoenix.PubSub.
    """
  end

  defp package do
    [
      name: "hlclock_syncrhonizer",
      maintainers: ["Dave Lucia", "Bryan Naegele"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/simplebet/hlclock_synchronizer"}
    ]
  end

  def docs do
    [
      source_ref: "v#{@version}",
      source_url: "https://github.com/simplebet/hlclock_synchronizer",
      main: "HLClockSynchronizer"
    ]
  end
end
