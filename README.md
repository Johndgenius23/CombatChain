# **Combat Chain**  
_A Crypto Collectible Battler NFT Smart Contract for Blockchain Warriors_

## **Overview**  
**Combat Chain** is a decentralized smart contract built on the Stacks blockchain. It allows users to create, own, and battle unique NFT characters with distinct attributes. Each character can grow stronger by leveling up through victorious battles, making Combat Chain a dynamic and evolving ecosystem of warriors.

## **Core Features**  
1. **Character Creation**  
   Players can mint unique characters with various rarity levels that determine their base attributes.  
   - **Rarity Types**: Common, Rare, Legendary  
   - **Attributes**:  
     - **Attack**: Determines offensive power.  
     - **Defense**: Determines resistance to attacks.  
     - **Health**: Determines character's survivability.  
     - **Level**: Increases as the character wins battles.  
     - **Rarity**: Indicates the rarity of the character.

2. **Battles**  
   Engage in one-on-one battles where characters compete based on their attack and defense stats.  
   - Characters owned by the same player cannot battle each other.  
   - The winner is recorded in the **Battle History** map, and their stats and level increase.

3. **Leveling Up**  
   After successful battles, players can level up their characters to increase their stats:  
   - Attack +5  
   - Defense +5  
   - Health +10  
   - Level +1

4. **Ownership and Trading**  
   Each character is mapped to its owner's principal, ensuring provable ownership and enabling future trading on decentralized marketplaces.

---

## **Contract Architecture**

### **Data Structures**  

- **Characters** (`characters`)  
  Stores character details including name, attributes, and rarity.  
  ```clarity
  (define-map characters 
    {id: uint} 
    {
      name: (string-ascii 50),
      attack: uint,
      defense: uint,
      health: uint,
      level: uint,
      rarity: (string-ascii 20)
    }
  )
  ```

- **Character Ownership** (`character-owners`)  
  Maps character IDs to their respective owners.  
  ```clarity
  (define-map character-owners 
    {character-id: uint} 
    {owner: principal}
  )
  ```

- **Battle History** (`battle-history`)  
  Tracks the outcomes of battles, including participants and the winner.  
  ```clarity
  (define-map battle-history 
    {battle-id: uint} 
    {
      attacker-id: uint, 
      defender-id: uint, 
      winner-id: uint,
      timestamp: uint
    }
  )
  ```

---

## **Functions**

### **1. Create Character**  
Mint a new NFT character with a specified name and rarity.  
**Function:** `create-character`  
```clarity
(define-public (create-character (name (string-ascii 50)) (rarity (string-ascii 20)))
```  
- **Inputs:**  
  - `name`: Character's name (max 50 characters).  
  - `rarity`: Rarity level (`common`, `rare`, `legendary`).  
- **Outputs:**  
  Returns the character ID of the newly minted character.

---

### **2. Battle**  
Initiate a battle between two characters.  
**Function:** `battle`  
```clarity
(define-public (battle (attacker-id uint) (defender-id uint))
```  
- **Inputs:**  
  - `attacker-id`: Character ID of the attacking character.  
  - `defender-id`: Character ID of the defending character.  
- **Outputs:**  
  Returns the ID of the winning character.

---

### **3. Level Up**  
Increase the stats of a character after winning battles.  
**Function:** `level-up`  
```clarity
(define-public (level-up (character-id uint))
```  
- **Inputs:**  
  - `character-id`: The ID of the character to level up.  
- **Outputs:**  
  Returns `true` if the level-up is successful.

---

### **4. Get Character Details**  
Fetch the details of a character by ID.  
**Function:** `get-character-details`  
```clarity
(define-read-only (get-character-details (character-id uint))
```  
- **Output:**  
  Returns the character’s attributes.

---

### **5. Get Character Owner**  
Retrieve the owner of a specific character.  
**Function:** `get-character-owner`  
```clarity
(define-read-only (get-character-owner (character-id uint))
```  
- **Output:**  
  Returns the principal of the character's owner.

---

## **Error Codes**  
- **ERR-NOT-OWNER** (`u100`): The caller is not the owner of the character.  
- **ERR-INVALID-CHARACTER** (`u101`): The specified character does not exist.  
- **ERR-INSUFFICIENT-FUNDS** (`u102`): Insufficient funds to mint a character.  
- **ERR-BATTLE-NOT-ALLOWED** (`u103`): Battle between characters owned by the same player is not allowed.

---

## **Future Enhancements**  
- **Marketplace Integration**: Enable trading of characters on decentralized NFT marketplaces.  
- **Skill System**: Introduce additional skills and abilities for characters.  
- **Multiplayer Battles**: Allow team-based combat scenarios.  
- **Tournaments**: Host periodic tournaments with rewards for winners.  

---

## **Getting Started**  
1. **Deploy the Contract**:  
   Deploy the `Combat Chain` smart contract to the Stacks blockchain using a compatible development environment.

2. **Mint Characters**:  
   Use the `create-character` function to mint your first character.

3. **Engage in Battles**:  
   Challenge other players and start climbing the leaderboard of warriors!

---

**License:** MIT  
Combat Chain is open-source and free to use. Contribute and help us make it the ultimate blockchain battler!