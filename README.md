# Running Quantum on multiple nodes

![gif](https://user-images.githubusercontent.com/6866370/59638900-fd429380-912f-11e9-82f2-849e1f085929.gif)

This example is taken from [quantum_swarm](https://github.com/peek-travel/quantum_swarm) but uses a single mix application instead of an Phoenix umbrella application.

## Setup

Just run `docker-compose build` to set everything up.

## Usage

Start the application with `docker-compose up`. After a while, you should start
to receives messages like the following every second:
```
sample_app_1  | 21:10:40.001 [warn]  Hello from sample_app@192.168.96.2
```

Then in a separate session, you can issue `docker-compose up --scale
sample_app=X -d` where `X` is the new total number of running instances.

```
sample_app_3  | 
sample_app_3  | 21:15:43.004 [warn]  Hello from sample_app@192.168.96.4
sample_app_3  | 
sample_app_3  | 21:15:44.003 [warn]  Hello from sample_app@192.168.96.4
sample_app_2  | 
sample_app_2  | 21:15:45.001 [warn]  Hello from sample_app@192.168.96.3
sample_app_2  | 
sample_app_2  | 21:15:46.001 [warn]  Hello from sample_app@192.168.96.3
sample_app_2  | 
sample_app_2  | 21:15:47.002 [warn]  Hello from sample_app@192.168.96.3
sample_app_1  | 
sample_app_1  | 21:15:48.003 [warn]  Hello from sample_app@192.168.96.2
```

## Todo

A couple of things might need some investigating.

### On Scale Up

When scaling up, I looks like the first instance receives a `:shutdown`. I still
need to figure out if this comes either from the way `docker-compose up --scale`
works or not. In either case this could be problematic if the shutdown happens
before state synchronization between the nodes.

```
sample_app_1  | 21:11:38.278 [error] GenServer SampleApp.Scheduler.ExecutorSupervisor terminating
sample_app_1  | ** (stop) no process: the process is not alive or there's no process currently associated with the given name, possibly because its application isn't started
sample_app_1  | Last message: {:DOWN, #Reference<0.1320933371.735313921.234648>, :process, #PID<0.1278.0>, :noproc}
sample_app_1  |
sample_app_1  | 21:11:38.278 [warn]  [swarm on sample_app@192.168.96.2] [tracker:handle_topology_change] handoff failed for SampleApp.Scheduler.ExecutionBroadcaster: {:shutdown, {GenServer, :call, [#PID<0.1278.0>, {:swarm, :begin_handoff}, 5000]}}
```

### On scale down

Any remaining node is considered the source of truth. We probably should
investigate if there is the possibility of losing information in such a case.
