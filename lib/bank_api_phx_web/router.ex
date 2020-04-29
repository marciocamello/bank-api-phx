defmodule BankApiPhxWeb.Router do
  use BankApiPhxWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Our pipeline implements "maybe" authenticated. We'll use the `:ensure_auth` below for when we need to make sure someone is logged in.
  pipeline :auth do
    plug BankApiPhxWeb.Auth.Pipeline
  end

  # We use ensure_auth to fail if there is no one logged in
  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", BankApiPhxWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", BankApiPhxWeb do
     pipe_through [:api]

     post "/account/create", AccountController, :create
     post "/auth/login", AuthController, :login
  end

  scope "/api", BankApiPhxWeb do
    pipe_through [:api, :auth, :ensure_auth]

    get "/account/index", AccountController, :index
    post "/account/withdrawal", AccountController, :withdrawal
    post "/account/transfer", AccountController, :transfer
    get "/account/terminate", AccountController, :terminate
  end

  scope "/api", BankApiPhxWeb do
    pipe_through [:api, :auth, :ensure_auth]

    resources "/users", UserController
    post "/transactions/report", TransactionController, :report
  end
end
