defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MyAppWeb do
    pipe_through :api
    resources "/things", SLRTaskController, except: [:update, :delete, :edit, :new]
    options "/things", SLRTaskController, :nothing
  end
end
