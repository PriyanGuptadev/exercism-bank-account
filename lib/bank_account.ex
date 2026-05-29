defmodule BankAccount do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, 0)
  end

  @impl true
  def init(balance) do
    {:ok, balance}
  end
end