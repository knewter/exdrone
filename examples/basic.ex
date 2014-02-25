defmodule Examples.Basic do
  alias Exdrone.Drone, as: D

  def start do
    connection = Exdrone.Connection[host: {192,168,1,1}, port: 5556]
    {:ok, drone} = D.start(connection)
    drone |> D.take_off
    :timer.sleep(2000)
    drone |> D.hover
    :timer.sleep(1000)
    drone |> D.forward(0.1)
    :timer.sleep(2000)
    drone |> D.land
    Process.exit(drone, :kill)
  end
end
