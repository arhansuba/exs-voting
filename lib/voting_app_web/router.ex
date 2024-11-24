defmodule VotingAppWeb.Router do
 use VotingAppWeb, :router

 pipeline :browser do
   plug :accepts, ["html"]
   plug :fetch_session
   plug :fetch_live_flash
   plug :put_root_layout, html: {VotingAppWeb.Layouts, :root}
   plug :protect_from_forgery
   plug :put_secure_browser_headers
 end

 pipeline :api do
   plug :accepts, ["json"]
 end

 pipeline :api_authenticated do
   plug :accepts, ["json"]
   # Add authentication plugs here when needed
 end

 # Browser routes
 scope "/", VotingAppWeb do
   pipe_through :browser

   # Main pages
   get "/", PageController, :home
   get "/results", PageController, :results
   get "/how-it-works", PageController, :how_it_works

   # Voting
   post "/vote", PageController, :vote

   # Wallet
   post "/wallet/connect", PageController, :connect_wallet
   post "/wallet/disconnect", PageController, :disconnect_wallet
 end

 # API endpoints
 scope "/api", VotingAppWeb do
   pipe_through :api

   scope "/v1" do
     get "/results", ApiController, :get_results
     get "/options", ApiController, :get_options
   end
 end

 # Protected API endpoints
 scope "/api", VotingAppWeb do
   pipe_through [:api, :api_authenticated]

   scope "/v1" do
     post "/admin/reset", ApiController, :reset_voting
     post "/admin/add-option", ApiController, :add_option
   end
 end

 # Enable LiveDashboard in development
 if Mix.env() in [:dev, :test] do
   import Phoenix.LiveDashboard.Router

   scope "/" do
     pipe_through :browser
     live_dashboard "/dashboard", metrics: VotingAppWeb.Telemetry
   end
 end
end
