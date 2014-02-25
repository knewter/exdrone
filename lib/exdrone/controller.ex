defmodule Exdrone.Controller do
  alias Exdrone.AtCommander
  use ExActor.GenServer
  use Bitwise

  @flags [
    hover: 0b00000000000000000000000000000000,
    move:  0b00000000000000000000000000000001,
  ]

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
    calibrate(state)
    initial_state(state)
  end

  defcall take_off, state: state do
    state = state.flying(true)
    state = state.emergency(false)
    state = update_ref(state)
    set_and_reply(state, self)
  end

  defcall land, state: state do
    state = state.flying(false)
    state = update_ref(state)
    set_and_reply(state, self)
  end

  defcall forward(amount), state: state do
    state = state.moving(true)
    state = state.pitch(-1 * amount)
    state = update_pcmd(state)
    set_and_reply(state, self)
  end

  defcall right(amount), state: state do
    state = state.moving(true)
    state = state.yaw(-1 * amount)
    state = update_pcmd(state)
    set_and_reply(state, self)
  end

  defcall hover, state: state do
    state = state.moving(false)
    state = update_pcmd(state)
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
    state.at_commander(state.at_commander |> AtCommander.ref(n))
  end

  def update_pcmd(state) do
    case state.moving do
      true ->
        flags = @flags[:move]
        iroll  = float_to_32int(state.roll)
        ipitch = float_to_32int(state.pitch)
        igaz   = float_to_32int(state.gaz)
        iyaw   = float_to_32int(state.yaw)
        data = "#{flags},#{iroll},#{ipitch},#{igaz},#{iyaw}"
      false ->
        flags = @flags[:hover]
        data = "0,0,0,0,0"
    end
    state.at_commander(state.at_commander |> AtCommander.pcmd(data))
  end

  def calibrate(state) do
    state.at_commander(state.at_commander |> AtCommander.ftrim)
  end

  defp float_to_32int(float_value) do
    <<int_value :: [size(32), signed] >> = <<float_value ::[float, size(32)]>>

    int_value
  end
end
