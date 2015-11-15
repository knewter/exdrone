defmodule Exdrone.Drone do
  use GenServer
  alias Exdrone.UdpSender
  alias Exdrone.AtCommander
  alias Exdrone.Controller

  defmodule State do
    defstruct controller: nil, seq: 1
  end

  def start_link(connection \\ %Exdrone.Connection{host: {192,168,1,1}, port: "5556"}) do
    GenServer.start_link(__MODULE__, connection, [])
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

  def init(connection) do
    sender            = UdpSender.start(connection)
    {:ok, commander}  = AtCommander.start(sender)
    {:ok, controller} = Controller.start(commander)
    {:ok, %State{controller: controller}}
  end

  def handle_call(:take_off, _from, state) do
    {:reply, Controller.take_off(state.controller), state}
  end

  def handle_call(:land, _from, state) do
    {:reply, Controller.land(state.controller), state}
  end

  def handle_call({:forward, amount}, _from, state) do
    {:reply, Controller.forward(state.controller, amount), state}
  end

  def handle_call({:right, amount}, _from, state) do
    {:reply, Controller.right(state.controller, amount), state}
  end

  def handle_call(:hover, state) do
    {:reply, Controller.hover(state.controller), state}
  end
end
