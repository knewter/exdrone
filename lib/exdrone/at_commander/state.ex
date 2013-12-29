defrecord Exdrone.AtCommander.State,
            buffer: "",
            ref_data: "0",
            pcmd_data: "0,0,0,0,0",
            seq: 0,
            interval: 0.2,
            sender: nil do

  def build_message(state) do
    state.buffer
  end

  def build_tick(state) do
    state = state.build_command("REF", state.ref_data)
    state.build_command("PCMD", state.pcmd_data)
  end

  def ref(state, data) do
    state.ref_data(data)
  end

  def pcmd(state, data) do
    state.pcmd_data(data)
  end

  def config(state, key, value) do
    state.build_command("CONFIG", "#{key},#{value}")
  end

  def comwdg(state) do
    state.build_command("COMWDG")
  end

  def ctrl(state, mode) do
    state.build_command("CTRL", "#{mode},0")
  end

  def build_command(name, args, state) do
    state = state.seq(state.seq + 1)
    command = "AT*#{name}=#{state.seq},#{args}\r"
    state.buffer(state.buffer <> command)
  end
  def build_command(name, state) do
    state = state.seq(state.seq + 1)
    command = "AT*#{name}=#{state.seq}\r"
    state.buffer(state.buffer <> command)
  end
end
