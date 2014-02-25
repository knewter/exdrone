defmodule Examples.Basic do
  alias Exdrone.Drone, as: D

  def start do
    connection = Exdrone.Connection[host: {192,168,1,1}, port: 5556]
    {:ok, drone} = D.start(connection)
    take_off(drone)
    forward(drone)
    spin(drone)
    land(drone)
    Process.exit(drone, :kill)
  end

  defp take_off(drone) do
    drone |> D.take_off
    :timer.sleep(2000)
  end

  defp land(drone) do
    drone |> D.land
    :timer.sleep(2000)
  end

  defp forward(drone) do
    drone |> D.forward(0.1)
    :timer.sleep(2000)
  end

  defp spin(drone) do
    drone |> D.right(0.1)
    :timer.sleep(2000)
  end
end
