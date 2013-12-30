defmodule Exdrone.Mixfile do
  use Mix.Project

  def project do
    [ app: :exdrone,
      version: "0.0.1",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
      applications: [
        :exlager
      ],
      mod: { Exdrone, [] }
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [
      {:mock, github: "jjh42/mock"},
      {:exactor, github: "sasa1977/exactor"},
      {:exlager, github: "khia/exlager"}
    ]
  end
end
