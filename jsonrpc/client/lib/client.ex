defmodule Client do
  alias JSONRPC2.Clients.HTTP

  @moduledoc """
  Documentation for Client.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Client.hello()
      :world

  """
  def hello do
    :world
  end

  @url "http://localhost:4000/"

  def hello(name) do
    HTTP.call(@url, "hello", [name])
  end

  def hello2(args) do
    HTTP.call(@url, "hello2", Map.new(args))
  end

  def notify(name) do
    HTTP.notify(@url, "notify", [name])
  end

end
