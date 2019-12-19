defmodule MyAppWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :my_app

  socket "/socket", MyAppWeb.UserSocket,
    websocket: true,
    longpoll: false

  # plug :debugprint
  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :my_app,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_my_app_key",
    signing_salt: "fBHHVrac"

  plug Corsica,
    origins: "*",
    allow_credentials: true,
    allow_headers: :all,
    log: [rejected: :error, invalid: :warn, accepted: :debug]

  plug MyAppWeb.Router

  # defp debugprint(conn, _opts) do
  #   # IO.inspect(conn)
  #   IO.inspect(get_req_header(conn, "access-control-allow-headers"),
  #     label: "wahoo-access-control-allow-headers")
  #   conn
  # end
end
