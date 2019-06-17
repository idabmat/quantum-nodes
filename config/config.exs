use Mix.Config

config :sample_app, SampleApp.Scheduler,
  global: true,
  jobs: [
    {{:extended, "*/1"}, {SampleApp.Task, :execute, []}}
  ]

config :libcluster,
  debug: true,
  topologies: [
    dns: [
      strategy: Cluster.Strategy.DNSPoll,
      config: [
        polling_interval: 5_000,
        query: "sample_app",
        node_basename: "sample_app"
      ]
    ]
  ]

config :logger, level: :info
