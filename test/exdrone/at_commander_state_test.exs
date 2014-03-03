defmodule AtCommander.StateTest do
  use ExUnit.Case
  alias Exdrone.AtCommander.State, as: S
  import Exdrone.CommandsHelper

  test "build_tick - with no commands" do
    expected_message = ref_command(1) <> pcmd_command(2)
    message = %S{} |> S.build_tick |> S.build_message
    assert message == expected_message
  end

  test "build_tick - with a ref command" do
    expected_message = ref_command(1, "512") <> pcmd_command(2)
    message = %S{} |> S.ref("512") |> S.build_tick |> S.build_message
    assert message == expected_message
  end

  test "build_tick - with a pcmd command" do
    expected_message = ref_command(1) <> pcmd_command(2, "1,2,3,4,5")
    message = %S{} |> S.pcmd("1,2,3,4,5") |> S.build_tick |> S.build_message
    assert message == expected_message
  end

  test "build_tick - with a config command" do
    expected_message = config_command(1, "general:navdata_demo", "TRUE") <> ref_command(2) <> pcmd_command(3)
    message = %S{} |> S.config("general:navdata_demo", "TRUE") |> S.build_tick |> S.build_message
    assert message == expected_message
  end

  test "build_tick - with a reset watchdog command" do
    expected_message = command(1, "COMWDG") <> ref_command(2) <> pcmd_command(3)
    message = %S{} |> S.comwdg |> S.build_tick |> S.build_message
    assert message == expected_message
  end

  test "build_tick - with a control command" do
    expected_message = ctrl_command(1, 4) <> ref_command(2) <> pcmd_command(3)
    message = %S{} |> S.ctrl(4) |> S.build_tick |> S.build_message
    assert message == expected_message
  end
end
