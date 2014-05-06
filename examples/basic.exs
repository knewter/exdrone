defmodule Examples.Basic do
  alias Exdrone.Drone, as: D

  def start do
    connection = %Exdrone.Connection{host: {192,168,1,1}, port: 5556}
    {:ok, drone} = D.start(connection)
    drone |> D.take_off
    :timer.sleep(1000)
    drone |> D.hover
    :timer.sleep(2000)
    for _ <- 1..3, do: forward_and_backwards(drone)
    drone |> D.hover
    :timer.sleep(2000)
    drone |> D.land
    :timer.sleep(2000)
    Process.exit(drone, :kill)
  end

  def forward_and_backwards(drone) do
    drone |> D.forward(0.15)
    :timer.sleep(1500)
    drone |> D.forward(-0.15)
    :timer.sleep(1500)
  end
end

Examples.Basic.start
