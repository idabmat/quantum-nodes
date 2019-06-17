defmodule SampleApp.Task do
  require Logger

  def execute do
    Logger.warn("Hello from #{Node.self()}")
  end
end
