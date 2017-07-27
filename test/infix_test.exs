defmodule InfixTest do
  use ExUnit.Case
  doctest Infix

  test "greets the world" do
    assert Infix.hello() == :world
  end
end
