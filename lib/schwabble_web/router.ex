defmodule SchwabbleWeb.Router do
  use SchwabbleWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SchwabbleWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SchwabbleWeb do
    pipe_through :browser

    live "/posts", PostLive.Index, :index
    live "/posts/new", PostLive.Form, :new
    live "/posts/:id", PostLive.Show, :show
    live "/posts/:id/edit", PostLive.Form, :edit

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", SchwabbleWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:schwabble, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SchwabbleWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
