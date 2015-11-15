defmodule Exdrone.AtCommander do
  use GenServer

  alias Exdrone.AtCommander.State
  alias Exdrone.UdpSender

  defmodule ServerState do
    defstruct commander_state: nil, sender: nil, timer: nil
  end

  def start(sender) do
    GenServer.start(__MODULE__, sender, [])
  end

  def init(sender) do
    {:ok, timer} = :timer.apply_interval(30, Exdrone.AtCommander, :tick, [self])
    {:ok, %ServerState{commander_state: %State{}, sender: sender, timer: timer}}
  end

  def tick(pid) do
    GenServer.call(pid, :tick)
  end

  def ref(pid, data) do
    GenSever.call(pid, {:ref, data})
  end

  def ftrim(pid) do
    GenServer.call(pid, :ftrim)
  end

  def handle_call(:tick, _from, state) do
    commander_state = state.commander_state |> State.build_tick
    message = commander_state |> State.build_message
    state.sender |> UdpSender.send_packet(message)
    commander_state = %State{commander_state | buffer: ""}
    state = %ServerState{state | commander_state: commander_state}
    {:reply, self, state}
  end

  def handle_call({:ref, data}, _from, state) do
    state = %ServerState{state | commander_state: state.commander_state |> State.ref(data)}
    {:reply, self, state}
  end

  def handle_call({:pcmd, data}, _from, state) do
    state = %ServerState{state | commander_state: state.commander_state |> State.pcmd(data)}
    {:reply, self, state}
  end

  def handle_call(:ftrim, _from, state) do
    state = %ServerState{state | commander_state: state.commander_state |> State.ftrim}
    {:reply, self, state}
  end

  def terminate(_, state) do
    :timer.cancel(state.timer)
  end
end
