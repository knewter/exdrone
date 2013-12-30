defmodule Exdrone.Controller do
  alias Exdrone.AtCommander
  use ExActor
  use Bitwise

  defrecord State,
    at_commander: nil,
    flying: false,
    emergency: false,
    moving: false,
    roll: 0,
    pitch: 0,
    yaw: 0,
    gaz: 0

  definit(at_commander) do
    state = State[at_commander: at_commander]
    update_ref(state)
    state
  end

  defcall take_off, state: state do
    state.at_commander |> AtCommander.ref(nil)
    state = state.flying(true)
    state = state.emergency(false)
    update_ref(state)
    set_and_reply(state, self)
  end

  def ref_base do
    # From: https://www.robotappstore.com/Knowledge-Base/How-to-Make-ARDrone-Take-Off-or-Land/97.html
    # turn on bits (0 indexed): 18, 20, 22, 24, 28
    0
      |> bor(1<<<18)
      |> bor(1<<<20)
      |> bor(1<<<22)
      |> bor(1<<<24)
      |> bor(1<<<28)
  end
  def ref_fly_bit, do: 1 <<< 9
  def ref_emergency_bit, do: 1 <<< 8

  def update_ref(state) do
    n = ref_base
    if state.flying, do: n = n |> bor(ref_fly_bit)
    if state.emergency, do: n = n |> bor(ref_emergency_bit)
    state.at_commander |> AtCommander.ref(n)
  end
end

