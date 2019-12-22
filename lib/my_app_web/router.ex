defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MyAppWeb do
    pipe_through :api
    resources "/things", SLRTaskController, except: [:update, :delete, :edit, :new]
    options "/things", SLRTaskController, :nothing
    post "/lrt", PyTaskController, :lrt_create
    get "/lrt/:id", PyTaskController, :lrt_show
    get "/lrt", PyTaskController, :lrt_index
    get "/lrtclear", PyTaskController, :lrt_clear
    post "/lrthook", PyTaskController, :lrt_hook
    resources "/pytasks", PyTaskController, only: [:index, :show, :create, :delete]
    post "/pytasks/sync", PyTaskController, :task_sync_create

    resources "/jsonrpc", JsonRpcTaskController, only: [:index, :show, :create, :delete]
  end
end
