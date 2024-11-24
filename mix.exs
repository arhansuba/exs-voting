defmodule VotingApp.MixProject do
 use Mix.Project

 def project do
   [
     app: :voting_app,
     version: "0.1.0",
     elixir: "~> 1.14",
     elixirc_paths: elixirc_paths(Mix.env()),
     start_permanent: Mix.env() == :prod,
     aliases: aliases(),
     deps: deps()
   ]
 end

 def application do
   [
     mod: {VotingApp.Application, []},
     extra_applications: [:logger, :runtime_tools]
   ]
 end

 defp elixirc_paths(:test), do: ["lib", "test/support"]
 defp elixirc_paths(_), do: ["lib"]

 defp deps do
   [
     {:phoenix, "~> 1.7.9"},
     {:phoenix_html, "~> 3.3"},
     {:phoenix_live_reload, "~> 1.4", only: :dev},
     {:phoenix_live_view, "~> 0.20.1"},
     {:floki, ">= 0.30.0", only: :test},
     {:phoenix_live_dashboard, "~> 0.8.2"},
     {:esbuild, "~> 0.7", runtime: Mix.env() == :dev},
     {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
     {:telemetry_metrics, "~> 0.6"},
     {:telemetry_poller, "~> 1.0"},
     {:gettext, "~> 0.20"},
     {:jason, "~> 1.2"},
     {:plug_cowboy, "~> 2.5"},
     {:aeternity, "~> 1.0"},  # Aeternity SDK
     {:ex_doc, "~> 0.27", only: :dev, runtime: false},
     {:credo, "~> 1.6", only: [:dev, :test], runtime: false}
   ]
 end

 defp aliases do
   [
     setup: ["deps.get", "assets.setup", "assets.build"],
     "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
     "assets.build": ["tailwind default", "esbuild default"],
     "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
   ]
 end
end