defmodule BankAccount do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, 0)
  end

  @impl true
  def init(balance) do
    {:ok, balance}
  end

  def open_bank do
    start_link()
  end

  def balance(account) do
    GenServer.call(account, :balance)
  end

  @impl true
  def handle_call(:balance, _from, balance) do
    {:reply, balance, balance}
  end
end
