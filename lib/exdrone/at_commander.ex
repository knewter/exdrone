defmodule Exdrone.AtCommander do
  use ExActor
  alias Exdrone.AtCommander.State
  alias Exdrone.UdpSender

  defrecord ServerState, commander_state: nil, sender: nil

  definit(sender) do
    ServerState[commander_state: State.new, sender: sender]
  end

  defcall tick, state: state do
    commander_state = state.commander_state |> State.build_tick
    message = commander_state |> State.build_message
    state.sender |> UdpSender.send_packet(message)
    state = state.commander_state(commander_state)
    set_and_reply(state, :ok)
  end
end
