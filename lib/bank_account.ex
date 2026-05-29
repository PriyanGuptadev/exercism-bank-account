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

  def deposit(account, amount) when amount > 0 do
    GenServer.call(account, {:deposit, amount})
  end

  def deposit(_, _) do
    {:error, "invalid amount"}
  end

  @impl true
  def handle_call({:deposit, amount}, _from, balance) do
    updated_balance = balance + amount

    {:reply, {:ok, updated_balance}, updated_balance}
  end

  def withdraw(account, amount) when amount > 0 do
    GenServer.call(account, {:withdraw, amount})
  end

  def withdraw(_, _) do
    {:error, "invalid amount"}
  end

  @impl true
  def handle_call({:withdraw, amount}, _from, balance)
      when balance < amount do
    {:reply, {:error, "insufficient funds"}, balance}
  end

  @impl true
  def handle_call({:withdraw, amount}, _from, balance) do
    updated_balance = balance - amount

    {:reply, {:ok, updated_balance}, updated_balance}
  end
end