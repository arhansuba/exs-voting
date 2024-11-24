
# Blockchain Voting Application

A decentralized voting application built with Phoenix Framework and æternity blockchain for the Code Beam æternity Challenge: Elixir and Erlang Hackathon.

## About The Project

This voting dApp allows users to:
- Cast secure votes on the blockchain
- Track voting results in real-time  
- View blockchain transaction history
- Connect their æternity wallet

Built using:
- Phoenix Framework
- Elixir/Erlang
- æternity Blockchain
- Sophia Smart Contracts
- Tailwind CSS

## Features

### Secure Voting
- Each vote is recorded on the blockchain
- Immutable transaction history
- Transparent vote counting
- Duplicate vote prevention

### Real-time Updates 
- Live vote tallying
- Real-time result visualization
- Transaction confirmation tracking
- WebSocket-based updates

### Wallet Integration
- Seamless æternity wallet connection
- Transaction signing
- Account balance checking
- Network status monitoring

### User Interface
- Clean, modern design
- Mobile-responsive layout
- Interactive voting interface
- Real-time progress bars

## Technical Stack

### Frontend
- Phoenix Framework
- LiveView
- Tailwind CSS
- JavaScript

### Backend
- Elixir
- Phoenix
- WebSocket channels
- GenServer state management

### Blockchain
- æternity blockchain
- Sophia smart contracts
- State channels
- Oracle integration

## Smart Contract Features

```sophia
contract VotingSystem =
  record state = {
    votes: map(address, string),
    options: map(string, int),
    is_active: bool
  }

  entrypoint init() : state =
    { votes = {},
      options = {"option_a": 0, "option_b": 0},
      is_active = true }

  stateful entrypoint vote(option: string) : bool =
    require(state.is_active, "Voting is not active")
    require(option == "option_a" || option == "option_b", "Invalid option")
    require(Map.member(Call.caller, state.votes) == false, "Already voted")
```

## Getting Started

### Prerequisites
```bash
# Required versions
elixir ~> 1.14
phoenix ~> 1.7
node >= 14
æternity wallet
```

### Installation
```bash
# Clone repository
git clone https://github.com/arhansuba/exs-voting.git

# Install dependencies
cd exs-voting
mix deps.get

# Install Node.js dependencies
cd assets && npm install && cd ..

# Start Phoenix server
mix phx.server
```

### Environment Setup
```env
AETERNITY_NODE_URL=https://testnet.aeternity.io
AETERNITY_NETWORK_ID=ae_uat
VOTING_CONTRACT_ADDRESS=your_contract_address
```

## Development

### Server
```elixir
# Start Phoenix server
mix phx.server

# Start IEx with Phoenix
iex -S mix phx.server

# Run tests
mix test
```

### Smart Contract
```sophia
# Deploy contract
æ contract deploy voting_contract.aes

# Interact with contract
æ contract call vote "option_a"
```

## API Endpoints

### Browser Routes
```elixir
GET  /          # Home page
POST /vote      # Submit vote
GET  /results   # View results
```

### API Routes
```elixir
GET  /api/v1/results     # Get current results
POST /api/v1/votes       # Submit vote
GET  /api/v1/status      # Check system status
```

## Contributing

1. Fork the project
2. Create feature branch
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. Commit changes
   ```bash
   git commit -m "Add AmazingFeature"
   ```
4. Push to branch
   ```bash
   git push origin feature/AmazingFeature
   ```
5. Open Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Contact

Your Name - [@arhansubasi0](https://twitter.com/your_twitter)

Project Link: [https://github.com/arhansuba/exs-voting](https://github.com/arhansuba/exs-voting)

