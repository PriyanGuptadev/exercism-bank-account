# Concurrent Banking System in Elixir

A concurrency-safe banking system built using Elixir and OTP.

## Features

* Open and close bank accounts
* Deposit and withdraw money safely
* Prevent overdrafts
* Prevent operations on closed accounts
* Concurrent transaction safety using GenServer
* Automated tests with ExUnit

---

## Tech Stack

* Elixir
* Erlang/OTP
* GenServer
* ExUnit

---

## Setup

### Requirements

Install:

* Erlang/OTP
* Elixir

Check installation:

```bash
elixir -v
```

---

## Run Project

Clone the project and install dependencies:

```bash
mix deps.get
```

Compile:

```bash
mix compile
```

Start interactive shell:

```bash
iex -S mix
```

---

## Usage

### Open Account

```elixir
{:ok, account} = BankAccount.open_bank()
```

### Deposit

```elixir
BankAccount.deposit(account, 500)
```

### Withdraw

```elixir
BankAccount.withdraw(account, 200)
```

### Check Balance

```elixir
BankAccount.balance(account)
```

### Close Account

```elixir
BankAccount.close_bank(account)
```

---

## Concurrency Example

```elixir
tasks =
  for _ <- 1..100 do
    Task.async(fn ->
      BankAccount.deposit(account, 10)
    end)
  end

Enum.each(tasks, &Task.await/1)
```

Final balance:

```elixir
{:ok, 1000}
```

This ensures safe concurrent updates without race conditions.

---

## Run Tests

```bash
mix test
```
