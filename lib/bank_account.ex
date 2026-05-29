defmodule BankAccount do
  use GenServer

  def start_link do
    initial_state = %{
      balance: 0,
      closed: false
    }

    GenServer.start_link(__MODULE__, initial_state)
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
  def handle_call(:balance, _from, state) do
    {:reply, {:ok, state.balance}, state}
  end

  def deposit(account, amount) when amount > 0 do
    GenServer.call(account, {:deposit, amount})
  end

  def deposit(_, _) do
    {:error, "invalid amount"}
  end

  @impl true
  def handle_call({:deposit, amount}, _from, state) do
    updated_state = %{
      state
      | balance: state.balance + amount
    }

    {:reply, {:ok, updated_state.balance}, updated_state}
  end

  def withdraw(account, amount) when amount > 0 do
    GenServer.call(account, {:withdraw, amount})
  end

  def withdraw(_, _) do
    {:error, "invalid amount"}
  end

  @impl true
  def handle_call({:withdraw, amount}, _from, state)
      when state.balance < amount do
    {:reply, {:error, "insufficient funds"}, state}
  end

  def handle_call({:withdraw, amount}, _from, state) do
    updated_state = %{
      state
      | balance: state.balance - amount
    }

    {:reply, {:ok, updated_state.balance}, updated_state}
  end

  def close_bank(account) do
    GenServer.call(account, :close)
  end

  @impl true
  def handle_call(:close, _from, state) do
    updated_state = %{
      state
      | closed: true
    }
    IO.inspect(state)
    {:reply, :ok, updated_state}
  end
end
