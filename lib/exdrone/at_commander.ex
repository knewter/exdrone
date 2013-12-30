defmodule Exdrone.AtCommander do
  use ExActor
  alias Exdrone.AtCommander.State
  alias Exdrone.UdpSender

  defrecord ServerState, commander_state: nil, sender: nil, timer: nil

  definit(sender) do
    {:ok, timer} = :timer.apply_interval(30, Exdrone.AtCommander, :tick, [self])
    ServerState[commander_state: State.new, sender: sender, timer: timer]
  end

  defcall tick, state: state do
    commander_state = state.commander_state |> State.build_tick
    message = commander_state |> State.build_message
    state.sender |> UdpSender.send_packet(message)
    commander_state = commander_state.buffer("")
    state = state.commander_state(commander_state)
    set_and_reply(state, self)
  end

  defcall ref(data), state: state do
    state = state.commander_state(state.commander_state |> State.ref(data))
    set_and_reply(state, self)
  end

  defcall ftrim, state: state do
    state = state.commander_state(state.commander_state |> State.ftrim)
    set_and_reply(state, self)
  end

  def terminate(_, state) do
    :timer.cancel(state.timer)
  end
end
