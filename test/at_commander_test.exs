defmodule AtCommanderTest do
  use ExUnit.Case
  alias Exdrone.AtCommander, as: C

  test "tick - with no commands" do
    expected_message = ref_command(1) <> pcmd_command(2)
    message = C.new |> C.tick |> C.build_message
    assert message == expected_message
  end

  test "tick - with a ref command" do
    expected_message = ref_command(1, "512") <> pcmd_command(2)
    message = C.new |> C.ref("512") |> C.tick |> C.build_message
    assert message == expected_message
  end

  test "tick - with a pcmd command" do
    expected_message = ref_command(1) <> pcmd_command(2, "1,2,3,4,5")
    message = C.new |> C.pcmd("1,2,3,4,5") |> C.tick |> C.build_message
    assert message == expected_message
  end

  test "tick - with a config command" do
    expected_message = config_command(1, "general:navdata_demo", "TRUE") <> ref_command(2) <> pcmd_command(3)
    message = C.new |> C.config("general:navdata_demo", "TRUE") |> C.tick |> C.build_message
    assert message == expected_message
  end

  test "tick - with a reset watchdog command" do
    expected_message = command(1, "COMWDG") <> ref_command(2) <> pcmd_command(3)
    message = C.new |> C.comwdg |> C.tick |> C.build_message
    assert message == expected_message
  end

  test "tick - with a control command" do
    expected_message = ctrl_command(1, 4) <> ref_command(2) <> pcmd_command(3)
    message = C.new |> C.ctrl(4) |> C.tick |> C.build_message
    assert message == expected_message
  end

  test "setting the interval" do
    commander = C.new
    commander = commander.interval(1.0)
    assert commander.interval == 1.0
  end

  def ref_command(seq, data // "0"), do: "AT\*REF=#{seq},#{data}\r"
  def pcmd_command(seq, data // "0,0,0,0,0"), do: "AT\*PCMD=#{seq},#{data}\r"
  def config_command(seq, key, value), do: "AT\*CONFIG=#{seq},#{key},#{value}\r"
  def ctrl_command(seq, mode), do: "AT\*CTRL=#{seq},#{mode},0\r"
  def command(seq, command), do: "AT\*#{command}=#{seq}\r"
end
