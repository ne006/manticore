defmodule ManticoreTest do
  use ExUnit.Case
  doctest Manticore

  test "greets the world" do
    assert Manticore.hello() == :world
  end
end
