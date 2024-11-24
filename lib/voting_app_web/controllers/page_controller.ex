defmodule VotingAppWeb.PageController do
 use VotingAppWeb, :controller
 
 # Plug to verify wallet connection before voting
 plug :verify_wallet when action in [:vote]

 def home(conn, _params) do
   with {:ok, votes} <- VotingApp.Blockchain.get_votes(),
        {:ok, blockchain_stats} <- get_blockchain_stats() do
     render(conn, :home, %{
       votes: votes,
       blockchain_stats: blockchain_stats,
       page_title: "Decentralized Voting",
       wallet_connected: get_session(conn, :wallet_address)
     })
   else
     {:error, reason} ->
       conn
       |> put_flash(:error, "Error loading data: #{reason}")
       |> render(:home, %{
         votes: %{"option_a" => 0, "option_b" => 0},
         blockchain_stats: default_blockchain_stats(),
         page_title: "Decentralized Voting",
         wallet_connected: get_session(conn, :wallet_address)
       })
   end
 end

 def vote(conn, %{"option" => option}) do
   wallet_address = get_session(conn, :wallet_address)

   with true <- valid_option?(option),
        {:ok, tx_hash} <- VotingApp.Blockchain.send_vote(option, wallet_address),
        {:ok, _receipt} <- wait_for_transaction(tx_hash) do
     
     VotingAppWeb.Endpoint.broadcast("votes:lobby", "new_vote", %{
       option: option,
       tx_hash: tx_hash
     })

     conn
     |> put_flash(:info, "Vote successfully recorded on the blockchain!")
     |> redirect(to: ~p"/")
   else
     false ->
       conn
       |> put_flash(:error, "Invalid voting option selected")
       |> redirect(to: ~p"/")
     
     {:error, :already_voted} ->
       conn
       |> put_flash(:error, "You have already voted in this election")
       |> redirect(to: ~p"/")
     
     {:error, reason} ->
       conn
       |> put_flash(:error, "Failed to record vote: #{reason}")
       |> redirect(to: ~p"/")
   end
 end

 # Helper functions
 defp verify_wallet(conn, _opts) do
   case get_session(conn, :wallet_address) do
     nil ->
       conn
       |> put_flash(:error, "Please connect your wallet to vote")
       |> redirect(to: ~p"/")
       |> halt()
     _address ->
       conn
   end
 end

 defp get_blockchain_stats do
   case VotingApp.Blockchain.get_stats() do
     {:ok, stats} -> {:ok, stats}
     {:error, _reason} -> {:ok, default_blockchain_stats()}
   end
 end

 defp default_blockchain_stats do
   %{
     latest_block: 0,
     total_transactions: 0,
     network_status: "unknown"
   }
 end

 defp valid_option?(option) when option in ["option_a", "option_b"], do: true
 defp valid_option?(_), do: false

 defp wait_for_transaction(tx_hash) do
   case VotingApp.Blockchain.wait_for_transaction(tx_hash, timeout: 30_000) do
     {:ok, receipt} -> {:ok, receipt}
     {:error, :timeout} -> {:error, "Transaction confirmation timeout"}
     {:error, reason} -> {:error, reason}
   end
 end
end
