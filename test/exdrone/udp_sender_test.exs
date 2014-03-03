defmodule UdpSenderTest do
  use ExUnit.Case
  import Mock
  alias Exdrone.Connection, as: Connection
  alias Exdrone.UdpSender, as: UdpSender

  test "with provided socket" do
    with_mock :gen_udp, [:unstick], [
      open: fn(0, [:binary]) -> {:ok, :socket} end,
      send: fn(:socket, {192,168,1,1}, 5550, "HI") -> :totes_worked end
    ] do
      connection = %Connection{host: {192,168,1,1}, port: 5550}
      assert :totes_worked == UdpSender.start(connection) |> UdpSender.send_packet("HI")
      assert called :gen_udp.open(0, [:binary])
      assert called :gen_udp.send(:socket, {192,168,1,1}, 5550, "HI")
    end
  end
end
