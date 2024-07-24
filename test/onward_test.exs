defmodule OnwardTest do
  use ExUnit.Case
  doctest Onward

  test "greets the world" do
    assert Onward.hello() == :world
  end
end
