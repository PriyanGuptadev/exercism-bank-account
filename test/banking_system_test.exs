defmodule BankingSystemTest do
  use ExUnit.Case
  doctest BankingSystem

  test "greets the world" do
    assert BankingSystem.hello() == :world
  end
end
