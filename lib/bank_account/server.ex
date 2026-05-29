defmodule BankAccount.Server do
  use GenServer

  @account_closed "account closed"
  @insufficient_funds "insufficient funds"

  # CLIENT

  def start_link do
    GenServer.start_link(__MODULE__, new_state())
  end

  # SERVER CALLBACKS

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:balance, _from, %{closed: true} = state) do
    {:reply, {:error, @account_closed}, state}
  end

  @impl true
  def handle_call(:balance, _from, state) do
    {:reply, {:ok, state.balance}, state}
  end

  @impl true
  def handle_call({:deposit, _amount}, _from, %{closed: true} = state) do
    {:reply, {:error, @account_closed}, state}
  end

  @impl true
  def handle_call({:deposit, amount}, _from, state) do
    updated_state = update_balance(state, amount)

    {:reply, {:ok, updated_state.balance}, updated_state}
  end

  @impl true
  def handle_call({:withdraw, _amount}, _from, %{closed: true} = state) do
    {:reply, {:error, @account_closed}, state}
  end

  @impl true
  def handle_call({:withdraw, amount}, _from, state)
      when state.balance < amount do
    {:reply, {:error, @insufficient_funds}, state}
  end

  @impl true
  def handle_call({:withdraw, amount}, _from, state) do
    updated_state = update_balance(state, -amount)

    {:reply, {:ok, updated_state.balance}, updated_state}
  end

  @impl true
  def handle_call(:close, _from, %{closed: true} = state) do
    {:reply, {:error, @account_closed}, state}
  end

  @impl true
  def handle_call(:close, _from, state) do
    updated_state = %{state | closed: true}

    {:reply, :ok, updated_state}
  end

  # PRIVATE HELPERS

  defp new_state do
    %{
      balance: 0,
      closed: false
    }
  end

  defp update_balance(state, amount) do
    %{
      state
      | balance: state.balance + amount
    }
  end
end
