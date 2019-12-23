defmodule Server do
  use JSONRPC2.Server.Handler

  @moduledoc """
  Documentation for Server.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Server.hello()
      :world

  """
  def hello do
    :world
  end

  def handle_request("hello", [name]) do
    "Hello, #{name}!"
  end

  def handle_request("hello2", %{"name" => name}) do
    "Hello again, #{name}!"
  end

  def handle_request("notify", [name]) do
    IO.puts("You have been notified, #{name}!")
  end

end
