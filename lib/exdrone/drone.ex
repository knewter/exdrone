defmodule Exdrone.Drone do
  use ExActor
  alias Exdrone.UdpSender
  alias Exdrone.AtCommander
  alias Exdrone.Controller

  defrecord State,
    controller: nil,
    seq: 1

  definit(connection // Exdrone.Connection[host: "192.168.1.1", port: "5556"]) do
    sender = UdpSender.start(connection)
    {:ok, commander} = AtCommander.start(sender)
    {:ok, controller} = Controller.start(commander)
    State[controller: controller]
  end

  defcall take_off, state: state do
    Controller.take_off(state.controller)
  end
end
