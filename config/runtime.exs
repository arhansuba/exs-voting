import Config

if config_env() == :prod do
 # The secret key base is used to sign/encrypt cookies and other secrets
 secret_key_base =
   System.get_env("SECRET_KEY_BASE") ||
     raise """
     environment variable SECRET_KEY_BASE is missing.
     You can generate one by calling: mix phx.gen.secret
     """

 host = System.get_env("PHX_HOST") || "example.com"
 port = String.to_integer(System.get_env("PORT") || "4000")

 config :voting_app, VotingAppWeb.Endpoint,
   url: [host: host, port: 443, scheme: "https"],
   http: [
     # Enable IPv6 and bind on all interfaces
     ip: {0, 0, 0, 0, 0, 0, 0, 0},
     port: port
   ],
   secret_key_base: secret_key_base

 # Configure Aeternity mainnet from environment variables
 config :voting_app, :aeternity,
   node_url: System.get_env("AETERNITY_NODE_URL") || "https://mainnet.aeternity.io",
   network_id: System.get_env("AETERNITY_NETWORK_ID") || "ae_mainnet",
   private_key: System.get_env("AETERNITY_PRIVATE_KEY"),
   contract_address: System.get_env("VOTING_CONTRACT_ADDRESS")
end
