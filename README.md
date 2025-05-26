# QuantumVault Smart Contract

A quantum-inspired gambling contract implementing Schrödinger's cat paradox on the Ethereum blockchain. Players create mystery boxes that exist in quantum superposition until observed, with prize outcomes determined by probabilistic quantum mechanics.

## Table of Contents

- [Overview](#overview)
- [Quantum Mechanics Concepts](#quantum-mechanics-concepts)
- [Contract Features](#contract-features)
- [How to Play](#how-to-play)
- [Game Mechanics](#game-mechanics)
- [Contract Functions](#contract-functions)
- [Events](#events)
- [Security Considerations](#security-considerations)
- [Deployment Guide](#deployment-guide)
- [Testing](#testing)
- [Gas Optimization](#gas-optimization)
- [Risk Disclosure](#risk-disclosure)

## Overview

QuantumVault is an experimental decentralized application that gamifies quantum physics concepts through blockchain technology. The contract creates a unique gaming experience where players' mystery boxes exist in superposition states until observation collapses their quantum wave function.

### Key Concepts

- **Quantum Superposition**: Boxes exist in both winning and losing states simultaneously
- **Wave Function Collapse**: Observing a box determines its final state
- **Quantum Entanglement**: Previous observations affect future outcomes
- **Schrödinger's Cat**: Boxes can "die" if left unobserved for too long

## Quantum Mechanics Concepts

### Schrödinger's Cat Paradox

The contract implements the famous thought experiment where a cat in a box is simultaneously alive and dead until observed. In our implementation:

- **The Cat**: Represents the prize state of each mystery box
- **The Box**: Contains both winning and losing states until opened
- **The Observer**: Players who collapse the quantum state by calling `observeBox()`
- **The Poison**: Time decay that eventually "kills" unobserved boxes

### Quantum Entanglement

Each observation affects subsequent observations through quantum entanglement:

```solidity
// Current box state becomes entangled with previous observer
box.hasPrize = (uint256(keccak256(abi.encodePacked(
    box.hasPrize,     // Current quantum state
    lastObserver      // Entanglement with last observer
))) % 2 == 0);
```

## Contract Features

### 🎲 Probabilistic Prize System
- 50% initial chance of winning (quantum superposition)
- Prize amount: 2x the original deposit
- Quantum entanglement affects probability

### ⏰ Time-Based Mechanics
- 7-day observation window per box
- Expired boxes trigger the "cat release" mechanism
- Time decay prevents indefinite superposition

### 💰 Jackpot System
- Accumulates all deposits into a shared pool
- Winners receive prizes from the jackpot
- "Cat release" distributes remaining funds

### 🔗 Quantum Entanglement
- Previous observations influence future outcomes
- Creates interconnected quantum states
- Adds strategic depth to timing decisions

## How to Play

### Step 1: Create a Mystery Box

```solidity
// Send at least 0.01 ETH to create your quantum box
quantumVault.createBox{value: 0.05 ether}();
```

**Requirements:**
- Minimum deposit: 0.01 ETH
- One box per address
- Box enters quantum superposition immediately

### Step 2: Wait or Observe

You have two choices:

**Option A: Observe Immediately**
```solidity
// Collapse the quantum state and see if you won
quantumVault.observeBox();
```

**Option B: Wait and Hope**
- Wait up to 7 days for optimal quantum entanglement
- Risk: Box may "die" if you wait too long
- Reward: Quantum entanglement may improve your odds

### Step 3: Check Your Results

```solidity
// View your box's current state
string memory state = quantumVault.boxSuperposition();
// Returns: "ALIVE/DEAD", "PRIZE", or "EMPTY"
```

### Step 4: Claim Winnings or Release the Cat

**If you won:**
- Prize automatically transferred during observation
- Receive 2x your original deposit

**If your box expired:**
```solidity
// Release Schrödinger's cat for random jackpot distribution
quantumVault.releaseTheCat();
```

## Game Mechanics

### Prize Calculation

| Scenario | Outcome | Prize |
|----------|---------|--------|
| Win (Observed) | Prize Found | 2x Deposit |
| Lose (Observed) | Empty Box | 0 ETH |
| Expired Box | Cat Released | Random Jackpot Distribution |

### Quantum States

```
Box Creation → [SUPERPOSITION] → Observation → [COLLAPSED STATE]
                     ↓                              ↓
               Time Expires                   WIN or LOSE
                     ↓
              [CAT RELEASED]
```

### Probability Matrix

| Condition | Win Probability |
|-----------|----------------|
| First Box (No Previous Observer) | 50% |
| Subsequent Boxes (With Entanglement) | ~50%* |
| After Cat Release | Variable |

*Exact probability depends on quantum entanglement effects

## Contract Functions

### Core Functions

#### `createBox() payable`
Creates a new mystery box in quantum superposition.

**Parameters:**
- `msg.value`: ETH deposit (minimum 0.01 ETH)

**Requirements:**
- Minimum 0.01 ETH deposit
- One box per address
- No existing active box

#### `observeBox()`
Collapses quantum state and determines prize outcome.

**Requirements:**
- Must have an active (living) box
- Must be within 7-day observation window
- Box must not have been previously observed

#### `releaseTheCat()`
Handles expired boxes and distributes random jackpot.

**Requirements:**
- Box must be expired (7+ days old)
- Box must still be in superposition (unobserved)

### View Functions

#### `boxSuperposition() → string`
Returns current quantum state of caller's box.

**Returns:**
- `"ALIVE/DEAD"`: Box in superposition
- `"PRIZE"`: Collapsed state with prize
- `"EMPTY"`: Collapsed state without prize

#### `getBoxInfo(address) → (uint256, uint256, bool, uint256)`
Returns detailed box information.

**Returns:**
- `deposit`: Original deposit amount
- `timestamp`: Box creation time
- `isAlive`: Current superposition status
- `timeRemaining`: Seconds until expiration

#### `getContractBalance() → uint256`
Returns total contract balance.

### Public Variables

- `boxes(address)`: Mapping of player addresses to their mystery boxes
- `BOX_LIFESPAN`: Constant 7-day observation period
- `jackpot`: Current total jackpot pool
- `totalPlayers`: Number of players who have created boxes
- `lastObserver`: Address of most recent observer (for entanglement)

## Events

### `BoxCreated(address indexed player, uint256 value)`
Emitted when a new mystery box is created.

### `BoxObserved(address indexed player, bool hasPrize)`
Emitted when a box is observed and state collapses.

### `CatReleased(uint256 jackpotDistributed)`
Emitted when Schrödinger's cat is released and jackpot distributed.

## Security Considerations

### Randomness Source
The contract uses a combination of:
- Previous block hash
- Player address
- Player count
- Timestamp

**Note:** This provides pseudo-randomness suitable for gaming but may be predictable by miners.

### Reentrancy Protection
- Uses simple state changes before external calls
- No complex external interactions during critical sections

### Access Control
- Functions protected by appropriate modifiers
- One box per address prevents spam
- Time-based restrictions prevent exploitation

### Economic Security
- Minimum deposit prevents dust attacks
- Prize payouts limited by contract balance
- Jackpot system prevents fund drainage

## Deployment Guide

### Prerequisites
- Solidity ^0.8.0
- Hardhat or Truffle development environment
- Testnet ETH for deployment

### Deployment Script

```javascript
// deploy.js
const { ethers } = require("hardhat");

async function main() {
  const QuantumVault = await ethers.getContractFactory("QuantumVault");
  const quantumVault = await QuantumVault.deploy();
  
  await quantumVault.deployed();
  
  console.log("QuantumVault deployed to:", quantumVault.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
```

### Verification

```bash
npx hardhat verify --network mainnet DEPLOYED_CONTRACT_ADDRESS
```

## Testing

### Test Coverage Areas

1. **Box Creation**
   - Minimum deposit validation
   - One box per address enforcement
   - Proper state initialization

2. **Quantum Mechanics**
   - Superposition state maintenance
   - Observation state collapse
   - Entanglement effects

3. **Time Mechanics**
   - Expiration handling
   - Cat release functionality
   - Time boundary conditions

4. **Economic Model**
   - Prize distribution accuracy
   - Jackpot management
   - Balance sufficiency checks

### Sample Test

```javascript
describe("QuantumVault", function () {
  it("Should create box in superposition", async function () {
    const [owner] = await ethers.getSigners();
    const quantumVault = await QuantumVault.deploy();
    
    await quantumVault.createBox({ value: ethers.utils.parseEther("0.1") });
    
    const state = await quantumVault.boxSuperposition();
    expect(state).to.equal("ALIVE/DEAD");
  });
});
```

## Gas Optimization

### Function Gas Costs (Estimated)

| Function | Gas Cost | Description |
|----------|----------|-------------|
| `createBox()` | ~100,000 | Box creation and storage |
| `observeBox()` | ~80,000 | State collapse and prize transfer |
| `releaseTheCat()` | ~70,000 | Cat release and distribution |
| `boxSuperposition()` | ~5,000 | View function |

### Optimization Strategies

1. **Struct Packing**: MysteryBox struct optimized for single storage slot
2. **Minimal External Calls**: Reduced gas costs through batching
3. **Efficient Randomness**: Single hash computation for multiple random values
4. **Event Indexing**: Strategic event parameter indexing

## Risk Disclosure

### Smart Contract Risks

- **Experimental Nature**: This is an experimental gambling contract
- **Pseudo-Randomness**: Randomness may be predictable by sophisticated actors
- **Economic Risk**: Players may lose their entire deposit
- **Time Risk**: Boxes may expire if not observed in time

### Technical Risks

- **Gas Price Volatility**: High gas prices may make small bets uneconomical
- **Network Congestion**: Ethereum network issues may prevent timely observations
- **Contract Bugs**: Despite testing, smart contracts may contain vulnerabilities

### Legal Considerations

- **Gambling Regulation**: May be subject to local gambling laws
- **Tax Implications**: Winnings may be subject to taxation
- **Jurisdiction Issues**: Legal status varies by location

## Advanced Strategies

### Optimal Timing

1. **Early Observation**: Guarantees participation but misses entanglement benefits
2. **Late Observation**: Risks expiration but may benefit from quantum entanglement
3. **Cat Release Timing**: Strategic timing for jackpot distribution

### Quantum Entanglement Exploitation

- Monitor `lastObserver` for entanglement opportunities
- Time observations after favorable previous outcomes
- Consider network effects of multiple simultaneous observations

### Risk Management

- Never bet more than you can afford to lose
- Diversify across multiple boxes (using different addresses)
- Monitor contract balance before large deposits

## Community and Development

### Contributing

This is an experimental project. Contributions welcome:

1. Fork the repository
2. Create feature branch
3. Add comprehensive tests
4. Submit pull request with detailed description

### Bug Reports

Report security issues privately to avoid exploitation.

### Future Enhancements

- Multi-dimensional quantum states
- Quantum interference effects
- Advanced entanglement mechanisms
- Cross-chain quantum bridges

## License

MIT License - See LICENSE file for details.

# Deployment Details

## **Deployed Contract Address:** [`0xCf7B8F6dE2Ff4f41E763a2507E2b4fF077f10637`](https://scan.test2.btcs.network/address/0xCf7B8F6dE2Ff4f41E763a2507E2b4fF077f10637)

## **Deployment Transaction:** [`0xc501c0dcf119c5131282830d40a6f2a0addeffe2a76197342a5f7b0ac0559de8`](https://scan.test2.btcs.network/tx/0xc501c0dcf119c5131282830d40a6f2a0addeffe2a76197342a5f7b0ac0559de8)

<img width="1401" alt="image" src="https://github.com/user-attachments/assets/a1836a0d-e0db-45e7-a769-80d15eaf4031" />
