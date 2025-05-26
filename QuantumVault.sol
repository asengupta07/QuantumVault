// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title QuantumVault
 * @dev A quantum-inspired gambling contract implementing Schrödinger's cat paradox
 * @notice Players create mystery boxes that exist in superposition until observed
 * @author Anonymous
 */
contract QuantumVault {
    
    /**
     * @dev Represents a mystery box with quantum properties
     * @param deposit The amount of ETH deposited to create the box
     * @param timestamp When the box was created
     * @param isAlive Whether the box is still in quantum superposition
     * @param hasPrize Whether the box contains a prize (determined probabilistically)
     */
    struct MysteryBox {
        uint256 deposit;      // ETH amount deposited
        uint256 timestamp;    // Block timestamp of box creation
        bool isAlive;         // True if box hasn't been observed yet
        bool hasPrize;        // True if box contains a winning prize
    }
    
    /// @dev Maps each player address to their mystery box
    mapping(address => MysteryBox) public boxes;
    
    /// @dev How long a box remains observable before it "dies"
    uint256 public constant BOX_LIFESPAN = 7 days;
    
    /// @dev Total jackpot pool accumulated from all deposits
    uint256 public jackpot;
    
    /// @dev Total number of players who have created boxes
    uint256 public totalPlayers;
    
    /// @dev Address of the last player who observed their box
    address public lastObserver;
    
    /// @dev Emitted when a new mystery box is created
    event BoxCreated(address indexed player, uint256 value);
    
    /// @dev Emitted when a box is observed and its state collapses
    event BoxObserved(address indexed player, bool hasPrize);
    
    /// @dev Emitted when the cat is released and jackpot is distributed
    event CatReleased(uint256 jackpotDistributed);
    
    /**
     * @dev Modifier to ensure the sender has a living (unobserved) box
     * @notice Reverts if the box is dead or doesn't exist
     */
    modifier onlyLivingBox() {
        require(boxes[msg.sender].isAlive, "Box is dead or never existed");
        _;
    }
    
    /**
     * @dev Creates a new mystery box in quantum superposition
     * @notice Requires minimum 0.01 ETH deposit and one box per address limit
     * @notice The box's prize state is determined probabilistically but not revealed
     */
    function createBox() external payable {
        // Validate minimum deposit amount
        require(msg.value >= 0.01 ether, "Minimum 0.01 ETH to create box");
        
        // Ensure one box per address (prevent spam)
        require(boxes[msg.sender].deposit == 0, "One box per address");
        
        // Generate quantum seed for prize determination
        // Uses previous block hash, sender address, and player count for randomness
        uint256 seed = uint256(keccak256(abi.encodePacked(
            blockhash(block.number - 1), 
            msg.sender, 
            totalPlayers
        )));
        
        // Create new mystery box with quantum superposition state
        boxes[msg.sender] = MysteryBox({
            deposit: msg.value,                    // Store the deposited amount
            timestamp: block.timestamp,           // Record creation time
            isAlive: true,                        // Box starts in superposition
            hasPrize: (seed % 2) == 0            // 50% chance of having prize
        });
        
        // Add deposit to total jackpot pool
        jackpot += msg.value;
        
        // Increment player counter
        totalPlayers++;
        
        // Emit creation event
        emit BoxCreated(msg.sender, msg.value);
    }
    
    /**
     * @dev Observes a mystery box, collapsing its quantum state
     * @notice Can only be called by box owner within the lifespan period
     * @notice Quantum entanglement affects prize probability based on last observer
     */
    function observeBox() external onlyLivingBox {
        // Get reference to the sender's box
        MysteryBox storage box = boxes[msg.sender];
        
        // Ensure observation happens within the allowed timeframe
        require(block.timestamp <= box.timestamp + BOX_LIFESPAN, "Observation period expired");
        
        // Quantum entanglement effect: if there was a previous observer,
        // the current box's state gets entangled and potentially altered
        if (lastObserver != address(0)) {
            // Re-calculate prize probability based on quantum entanglement
            // with the previous observer's influence
            box.hasPrize = (uint256(keccak256(abi.encodePacked(
                box.hasPrize,     // Current quantum state
                lastObserver      // Entanglement with last observer
            ))) % 2 == 0);        // 50% probability after entanglement
        }

        // Collapse the quantum state and distribute rewards
        if (box.hasPrize) {
            // Winner gets double their deposit back
            uint256 prize = box.deposit * 2;
            
            // Ensure contract has sufficient balance for payout
            require(prize <= address(this).balance, "Insufficient funds");
            
            // Transfer prize to winner
            payable(msg.sender).transfer(prize);
            
            // Reduce jackpot by prize amount
            jackpot -= prize;
        }
        
        // Collapse the quantum state (box is no longer alive)
        box.isAlive = false;
        
        // Record this observer for quantum entanglement effects
        lastObserver = msg.sender;
        
        // Emit observation event with result
        emit BoxObserved(msg.sender, box.hasPrize);
    }
    
    /**
     * @dev Releases Schrödinger's cat when a box expires unobserved
     * @notice Can only be called after the box lifespan expires
     * @notice Distributes half the jackpot to a random player
     */
    function releaseTheCat() external {
        // Ensure enough time has passed (box has "died" naturally)
        require(block.timestamp >= boxes[msg.sender].timestamp + BOX_LIFESPAN, "Too early");
        
        // Ensure the box is still in superposition (unobserved)
        require(boxes[msg.sender].isAlive, "Already observed");
        
        // Generate pseudo-random seed for selecting winner
        uint256 seed = uint256(keccak256(abi.encodePacked(
            block.timestamp,    // Current time for randomness
            msg.sender         // Caller address for additional entropy
        )));
        
        // Select random player based on total player count
        // Note: This is a simplified approach and may not distribute perfectly
        address randomPlayer = address(uint160(seed % totalPlayers));
        
        // Calculate half of current jackpot for distribution
        uint256 halfJackpot = jackpot / 2;
        
        // Transfer half jackpot to randomly selected player
        payable(randomPlayer).transfer(halfJackpot);
        
        // Reduce jackpot by distributed amount
        jackpot -= halfJackpot;
        
        // Emit cat release event with distributed amount
        emit CatReleased(halfJackpot);
    }
    
    /**
     * @dev Returns the current quantum state of the sender's box
     * @return A string representing the box's superposition or collapsed state
     * @notice "ALIVE/DEAD" indicates superposition, "PRIZE"/"EMPTY" indicates collapsed state
     */
    function boxSuperposition() external view returns(string memory) {
        // Check if box is still in quantum superposition
        if(boxes[msg.sender].isAlive) {
            return "ALIVE/DEAD";  // Schrödinger's superposition state
        }
        
        // Return collapsed state result
        return boxes[msg.sender].hasPrize ? "PRIZE" : "EMPTY";
    }
    
    /**
     * @dev Returns the current contract balance
     * @return The total ETH balance held by the contract
     */
    function getContractBalance() external view returns(uint256) {
        return address(this).balance;
    }
    
    /**
     * @dev Returns detailed information about a player's box
     * @param player The address of the player to query
     * @return deposit The amount deposited for the box
     * @return timestamp When the box was created
     * @return isAlive Whether the box is still in superposition
     * @return timeRemaining Seconds remaining before box expires (0 if expired)
     */
    function getBoxInfo(address player) external view returns(
        uint256 deposit,
        uint256 timestamp,
        bool isAlive,
        uint256 timeRemaining
    ) {
        MysteryBox storage box = boxes[player];
        deposit = box.deposit;
        timestamp = box.timestamp;
        isAlive = box.isAlive;
        
        // Calculate remaining time or return 0 if expired
        if (block.timestamp < box.timestamp + BOX_LIFESPAN) {
            timeRemaining = (box.timestamp + BOX_LIFESPAN) - block.timestamp;
        } else {
            timeRemaining = 0;
        }
    }
}
