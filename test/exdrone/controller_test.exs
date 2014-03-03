defmodule Exdrone.ControllerTest do
  use ExUnit.Case
  import Mock
  alias Exdrone.Controller
  alias Exdrone.AtCommander
  use Bitwise

  test "navigating - taking off" do
    with_mock AtCommander, commander_mocks do
      {:ok, controller} = Controller.start(:at_commander)
      output = controller |> Controller.take_off
      assert controller == output
      assert called AtCommander.ref(:at_commander, ref_bits(9))
    end
  end

  test "navigating - landing" do
    with_mock AtCommander, commander_mocks do
      {:ok, controller} = Controller.start(:at_commander)
      output = controller |> Controller.land
      assert controller == output
      assert called AtCommander.ref(:at_commander, ref_bits)
    end
  end

  defp ref_bits, do: Controller.ref_base
  defp ref_bits(n), do: Controller.ref_base |> bor(1<<<n)
  defp commander_mocks do
    [
      ref: fn(_commander, _bits) -> :ok end,
      ftrim: fn(commander) -> commander end
    ]
  end
end
