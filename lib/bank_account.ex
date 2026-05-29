defmodule BankAccount do
  alias BankAccount.Server

  @invalid_amount "invalid amount"

  @type account :: pid()

  @spec open_bank() :: {:ok, pid()}
  def open_bank do
    Server.start_link()
  end

  @spec balance(account()) ::
          {:ok, integer()} | {:error, String.t()}
  def balance(account) do
    GenServer.call(account, :balance)
  end

  @spec deposit(account(), integer()) ::
          {:ok, integer()} | {:error, String.t()}
  def deposit(account, amount) when amount > 0 do
    GenServer.call(account, {:deposit, amount})
  end

  def deposit(_, _) do
    {:error, @invalid_amount}
  end

  @spec withdraw(account(), integer()) ::
          {:ok, integer()} | {:error, String.t()}
  def withdraw(account, amount) when amount > 0 do
    GenServer.call(account, {:withdraw, amount})
  end

  def withdraw(_, _) do
    {:error, @invalid_amount}
  end

  @spec close_bank(account()) ::
          :ok | {:error, String.t()}
  def close_bank(account) do
    GenServer.call(account, :close)
  end
end
