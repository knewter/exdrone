defmodule Exdrone.UdpSender do
  defstruct [:connection, :socket]

  def start(connection) do
    {:ok, socket} = :gen_udp.open(0, [:binary])
    %__MODULE__{connection: connection, socket: socket}
  end

  def send_packet(udp_sender, packet) do
    connection = udp_sender.connection
    :gen_udp.send(udp_sender.socket, connection.host, connection.port, packet)
  end
end
