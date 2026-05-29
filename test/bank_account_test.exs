defmodule BankAccountTest do
  use ExUnit.Case

  test "opens account with zero balance" do
    {:ok, account} = BankAccount.open_bank()

    assert {:ok, 0} ==
             BankAccount.balance(account)
  end

  test "deposits money successfully" do
    {:ok, account} = BankAccount.open_bank()

    assert {:ok, 100} ==
             BankAccount.deposit(account, 100)

    assert {:ok, 100} ==
             BankAccount.balance(account)
  end

  test "withdraws money successfully" do
    {:ok, account} = BankAccount.open_bank()

    BankAccount.deposit(account, 200)

    assert {:ok, 150} ==
             BankAccount.withdraw(account, 50)

    assert {:ok, 150} ==
             BankAccount.balance(account)
  end

  test "prevents overdraft" do
    {:ok, account} = BankAccount.open_bank()

    assert {:error, "insufficient funds"} ==
             BankAccount.withdraw(account, 100)
  end

  test "rejects invalid deposits" do
    {:ok, account} = BankAccount.open_bank()

    assert {:error, "invalid amount"} ==
             BankAccount.deposit(account, -10)

    assert {:error, "invalid amount"} ==
             BankAccount.deposit(account, 0)
  end

  test "rejects invalid withdrawals" do
    {:ok, account} = BankAccount.open_bank()

    assert {:error, "invalid amount"} ==
             BankAccount.withdraw(account, -10)

    assert {:error, "invalid amount"} ==
             BankAccount.withdraw(account, 0)
  end

  test "closes account successfully" do
    {:ok, account} = BankAccount.open_bank()

    assert :ok ==
             BankAccount.close_bank(account)
  end

  test "prevents balance check on closed account" do
    {:ok, account} = BankAccount.open_bank()

    BankAccount.close_bank(account)

    assert {:error, "account closed"} ==
             BankAccount.balance(account)
  end

  test "prevents deposits on closed account" do
    {:ok, account} = BankAccount.open_bank()

    BankAccount.close_bank(account)

    assert {:error, "account closed"} ==
             BankAccount.deposit(account, 100)
  end

  test "prevents withdrawals on closed account" do
    {:ok, account} = BankAccount.open_bank()

    BankAccount.close_bank(account)

    assert {:error, "account closed"} ==
             BankAccount.withdraw(account, 50)
  end

  test "handles concurrent deposits safely" do
    {:ok, account} = BankAccount.open_bank()

    tasks =
      for _ <- 1..100 do
        Task.async(fn ->
          BankAccount.deposit(account, 10)
        end)
      end

    Enum.each(tasks, &Task.await/1)

    assert {:ok, 1000} ==
             BankAccount.balance(account)
  end
end