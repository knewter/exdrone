defmodule Exdrone do
  use Application

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Exdrone.Supervisor.start_link
  end
end
