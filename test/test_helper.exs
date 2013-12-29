ExUnit.start

defmodule Exdrone.CommandsHelper do
  def ref_command(seq, data // "0"), do: "AT\*REF=#{seq},#{data}\r"
  def pcmd_command(seq, data // "0,0,0,0,0"), do: "AT\*PCMD=#{seq},#{data}\r"
  def config_command(seq, key, value), do: "AT\*CONFIG=#{seq},#{key},#{value}\r"
  def ctrl_command(seq, mode), do: "AT\*CTRL=#{seq},#{mode},0\r"
  def command(seq, command), do: "AT\*#{command}=#{seq}\r"
end
