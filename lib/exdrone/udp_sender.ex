defrecord Exdrone.UdpSender, [:connection, :socket] do
  def start(connection) do
    {:ok, socket} = :gen_udp.open(0, [:binary])
    Exdrone.UdpSender.new(connection: connection, socket: socket)
  end

  def send_packet(udp_sender, packet) do
    connection = udp_sender.connection
    :gen_udp.send(udp_sender.socket, connection.host, connection.port, packet)
  end
end
