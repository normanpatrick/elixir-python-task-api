defmodule ClientTest do
  use ExUnit.Case
  doctest Client

  test "greets the world" do
    assert Client.hello() == :world
  end

  test "check the jsonrpc calls" do
    # Make a call with the client to the server
    assert {:ok, "Hello, Elixir!"} = IO.inspect(Client.hello("Elixir"))

    # Make a call with the client to the server, using named args
    assert {:ok, "Hello again, Elixir!"} = IO.inspect(Client.hello2(name: "Elixir"))

    # Notifications
    assert :ok == Client.notify("Elixir")
    # should have printed
    # => You have been notified, Elixir!
  end
end
