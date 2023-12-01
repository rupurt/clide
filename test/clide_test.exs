defmodule ClideTest do
  use ExUnit.Case
  doctest Clide

  test "greets the world" do
    assert Clide.hello() == :world
  end
end
