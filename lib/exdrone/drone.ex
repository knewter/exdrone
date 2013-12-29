defmodule Exdrone.Drone do
  defrecord State,
    connection: nil,
    seq: 1

  use ExActor

  definit(connection // Exdrone.Connection[host: "192.168.1.1", port: "5556"]) do
    State[connection: connection]
  end

  defcall take_off, state: State[connection: connection] do
    Exdrone.Controller.take_off(connection)
  end
end
