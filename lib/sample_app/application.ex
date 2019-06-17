defmodule SampleApp.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(SampleApp.Scheduler, [])
    ]

    children =
      case Application.get_env(:libcluster, :topologies) do
        nil ->
          children

        topologies ->
          [
            {Cluster.Supervisor, [topologies, [name: SampleApp.ClusterSupervisor]]}
            | children
          ]
      end

    opts = [strategy: :one_for_one, name: SampleApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
