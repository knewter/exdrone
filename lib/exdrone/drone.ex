defmodule Exdrone.Drone do
  use ExActor.GenServer
  alias Exdrone.UdpSender
  alias Exdrone.AtCommander
  alias Exdrone.Controller

  defrecord State,
    controller: nil,
    seq: 1

  definit(connection \\ Exdrone.Connection[host: {192,168,1,1}, port: "5556"]) do
    sender            = UdpSender.start(connection)
    {:ok, commander}  = AtCommander.start(sender)
    {:ok, controller} = Controller.start(commander)

    initial_state(State[controller: controller])
  end

  defcall take_off, state: state do
    set_and_reply(state, Controller.take_off(state.controller))
  end

  defcall land, state: state do
    set_and_reply(state, Controller.land(state.controller))
  end

  defcall forward(amount), state: state do
    set_and_reply(state, Controller.forward(state.controller, amount))
  end

  defcall right(amount), state: state do
    set_and_reply(state, Controller.right(state.controller, amount))
  end

  defcall hover, state: state do
    set_and_reply(state, Controller.hover(state.controller))
  end
end
