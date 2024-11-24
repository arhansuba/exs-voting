import Config

# Configure your database
config :voting_app, VotingAppWeb.Endpoint,
 # Binding to loopback ipv4 address prevents access from other machines
 http: [ip: {127, 0, 0, 1}, port: 4000],
 check_origin: false,
 code_reloader: true,
 debug_errors: true,
 secret_key_base: "YOUR_DEV_SECRET_KEY",
 watchers: [
   esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
   tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
 ]

# Watch static and templates for browser reloading
config :voting_app, VotingAppWeb.Endpoint,
 live_reload: [
   patterns: [
     ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
     ~r"lib/voting_app_web/(controllers|live|components)/.*(ex|heex)$"
   ]
 ]

# Enable dev routes for dashboard
config :voting_app, dev_routes: true

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Set a higher stacktrace during development
config :phoenix, :stacktrace_depth, 20

# Configure Aeternity testnet for development
config :voting_app, :aeternity,
 node_url: "https://testnet.aeternity.io",
 network_id: "ae_uat"
