defrecord Exdrone.AtCommander,
            buffer: "",
            ref_data: "0",
            pcmd_data: "0,0,0,0,0",
            seq: 0,
            interval: 0.2 do

  def build_message(commander) do
    IO.inspect commander.buffer
    commander.buffer
  end

  def tick(commander) do
    commander = commander.build_command("REF", commander.ref_data)
    commander.build_command("PCMD", commander.pcmd_data)
  end

  def ref(commander, data) do
    commander.ref_data(data)
  end

  def pcmd(commander, data) do
    commander.pcmd_data(data)
  end

  def config(commander, key, value) do
    commander.build_command("CONFIG", "#{key},#{value}")
  end

  def comwdg(commander) do
    commander.build_command("COMWDG")
  end

  def ctrl(commander, mode) do
    commander.build_command("CTRL", "#{mode},0")
  end

  def build_command(name, args, commander) do
    commander = commander.seq(commander.seq + 1)
    command = "AT*#{name}=#{commander.seq},#{args}\r"
    commander.buffer(commander.buffer <> command)
  end
  def build_command(name, commander) do
    commander = commander.seq(commander.seq + 1)
    command = "AT*#{name}=#{commander.seq}\r"
    commander.buffer(commander.buffer <> command)
  end
end
