defmodule Pummpcomm.Radio.ChipSupervisor do
  @moduledoc """
  This supervisor manages the underlying radio device processes once the chip type has been determined
  """

  use Supervisor

  alias Pummpcomm.Radio.ChipDetector
  alias Pummpcomm.Radio.ChipAgent

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_) do
    radio_chip = %{__struct__: radio_module} = ChipDetector.autodetect
    Supervisor.init([
      ChipAgent.child_spec(radio_chip),
      radio_module.child_spec(radio_chip)
    ], strategy: :one_for_one)
  end
end

defmodule Pummpcomm.Radio.ChipAgent do
  use Agent

  def start_link(chip) do
    Agent.start_link(fn -> chip end, name: __MODULE__)
  end

  def current do
    Agent.get(__MODULE__, &(&1))
  end
end