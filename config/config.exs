import Config

# Configures the endpoint
config :voting_app, VotingAppWeb.Endpoint,
 url: [host: "localhost"],
 render_errors: [
   formats: [html: VotingAppWeb.ErrorHTML, json: VotingAppWeb.ErrorJSON],
   layout: false
 ],
 pubsub_server: VotingApp.PubSub,
 live_view: [signing_salt: "YOUR_SIGNING_SALT"]

# Configure esbuild
config :esbuild,
 version: "0.17.11",
 default: [
   args: ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets),
   cd: Path.expand("../assets", __DIR__),
   env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
 ]

# Configure tailwind
config :tailwind,
 version: "3.3.2",
 default: [
   args: ~w(
     --config=tailwind.config.js
     --input=css/app.css
     --output=../priv/static/assets/app.css
   ),
   cd: Path.expand("../assets", __DIR__)
 ]

# Configure Aeternity blockchain settings
config :voting_app, :aeternity,
 node_url: System.get_env("AETERNITY_NODE_URL") || "https://testnet.aeternity.io",
 network_id: System.get_env("AETERNITY_NETWORK_ID") || "ae_uat",
 contract_address: System.get_env("VOTING_CONTRACT_ADDRESS")

# Configure logger
config :logger, :console,
 format: "$time $metadata[$level] $message\n",
 metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config
import_config "#{config_env()}.exs"
