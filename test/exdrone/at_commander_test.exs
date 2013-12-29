defmodule AtCommanderTest do
  use ExUnit.Case
  alias Exdrone.AtCommander, as: C
  alias Exdrone.Connection
  alias Exdrone.UdpSender
  import Mock
  import Exdrone.CommandsHelper

  test "tick - with no commands" do
    expected_message = ref_command(1) <> pcmd_command(2)
    connection = Connection[host: {192,168,1,1}, port: 5550]
    sender = UdpSender.start(connection)
    {:ok, commander} = C.start(sender)
    with_mock UdpSender, [send_packet: fn(_, _) -> :ok end] do
      C.tick(commander)
      assert called UdpSender.send_packet(sender, expected_message)
    end
  end
end
