defmodule Exdrone.Drone do
  use ExActor.GenServer
  alias Exdrone.UdpSender
  alias Exdrone.AtCommander
  alias Exdrone.Controller

  defrecord State,
    controller: nil,
    seq: 1

  definit(connection // Exdrone.Connection[host: {192,168,1,1}, port: "5556"]) do
    sender            = UdpSender.start(connection)
    {:ok, commander}  = AtCommander.start(sender)
    {:ok, controller} = Controller.start(commander)

    initial_state(State[controller: controller])
  end

  defcall take_off, state: state do
    Controller.take_off(state.controller)
    set_and_reply(state, self)
  end

  defcall land, state: state do
    Controller.land(state.controller)
    set_and_reply(state, self)
  end

  defcall forward(amount), state: state do
    Controller.forward(state.controller, amount)
    set_and_reply(state, self)
  end

  defcall right(amount), state: state do
    Controller.right(state.controller, amount)
    set_and_reply(state, self)
  end

  defcall hover, state: state do
    Controller.hover(state.controller)
    set_and_reply(state, self)
  end
end
