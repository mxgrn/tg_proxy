defmodule TgProxyTest do
  use ExUnit.Case
  doctest TgProxy

  test "greets the world" do
    assert TgProxy.hello() == :world
  end
end
