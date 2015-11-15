defmodule Exdrone.Controller do
  alias Exdrone.AtCommander

  use GenServer
  use Bitwise

  @flags [
    hover: 0b00000000000000000000000000000000,
    move:  0b00000000000000000000000000000001,
  ]

  defmodule State do
    defstruct at_commander: nil,
              flying: false,
              emergency: false,
              moving: false,
              roll: 0,
              pitch: 0,
              yaw: 0,
              gaz: 0
  end

  def start(at_commander) do
    GenServer.start(__MODULE__, at_commander)
  end

  def init(at_commander) do
    state = %State{at_commander: at_commander}
    update_ref(state)
    calibrate(state)
    {:ok, state}
  end

  def take_off(pid) do
    GenServer.call(pid, :take_off)
  end

  def land(pid) do
    GenServer.call(pid, :land)
  end

  def forward(pid, amount) do
    GenServer.call(pid, {:forward, amount})
  end

  def right(pid, amount) do
    GenServer.call(pid, {:right, amount})
  end

  def hover(pid) do
    GenServer.call(pid, :hover)
  end

  def handle_call(:take_off, _from, state) do
    state = %State{state | flying: true, emergency: false}
    state = update_ref(state)
    {:reply, self, state}
  end

  def handle_call(:land, _from, state) do
    state = %State{state | flying: false}
    state = update_ref(state)
    {:reply, self, state}
  end

  def handle_call({:forward, amount}, _from, state) do
    state = %State{state | moving: true, pitch: -1 * amount}
    state = update_pcmd(state)
    {:reply, self, state}
  end

  def handle_call({:right, amount}, _from, state) do
    state = %State{state | moving: true, yaw: -1 * amount}
    state = update_pcmd(state)
    {:reply, self, state}
  end

  def handle_call(:hover, _from, state) do
    state = %State{state | moving: false}
    state = update_pcmd(state)
    {:reply, self, state}
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
    at_commander = AtCommander.ref(state.at_commander, n)
    %State{state | at_commander: at_commander}
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
    %State{state | at_commander: state.at_commander |> AtCommander.pcmd(data)}
  end

  def calibrate(state) do
    %State{state | at_commander: state.at_commander |> AtCommander.ftrim}
  end

  defp float_to_32int(float_value) do
    <<int_value :: size(32)-signed >> = <<float_value :: size(32)-float >>

    int_value
  end
end
