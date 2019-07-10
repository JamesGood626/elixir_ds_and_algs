defmodule DsAndAlgsTest do
  use ExUnit.Case
  doctest DsAndAlgs

  test "greets the world" do
    assert DsAndAlgs.hello() == :world
  end
end
