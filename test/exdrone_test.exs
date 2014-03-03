defmodule ExdroneTest do
  use ExUnit.Case
  import Mock
  alias Exdrone.Drone, as: D
  alias Exdrone.Controller, as: C
  alias Exdrone.Connection, as: Connection

  setup do
    connection = Connection[host: {192,168,1,1}, port: 5556]
    {:ok, pid} = D.start_link(connection)
    {:ok, pid: pid, connection: connection}
  end

  test "take_off defers to the controller", meta do
    with_mock C, [take_off: fn(_controller) -> :called end] do
      assert :called == D.take_off(meta[:pid])
    end
  end

  test "land defers to the controller", meta do
    with_mock C, [land: fn(_controller) -> :called end] do
      assert :called == D.land(meta[:pid])
    end
  end
end
