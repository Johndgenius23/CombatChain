;; Crypto Collectible Battler NFT Smart Contract

;; Constants for contract errors
(define-constant ERR-NOT-OWNER (err u100))
(define-constant ERR-INVALID-CHARACTER (err u101))
(define-constant ERR-INSUFFICIENT-FUNDS (err u102))
(define-constant ERR-BATTLE-NOT-ALLOWED (err u103))

;; Character traits structure
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

;; Track character ownership
(define-map character-owners 
  {character-id: uint} 
  {owner: principal}
)

;; Battle history tracking
(define-map battle-history 
  {battle-id: uint} 
  {
    attacker-id: uint, 
    defender-id: uint, 
    winner-id: uint,
    timestamp: uint
  }
)

;; Minting fee and next character ID
(define-data-var mint-fee uint u10000000) ;; 0.1 STX
(define-data-var next-character-id uint u1)
(define-data-var total-characters uint u0)

;; Character Creation Function
(define-public (create-character 
  (name (string-ascii 50)) 
  (rarity (string-ascii 20))
)
  (let (
    (character-id (var-get next-character-id))
    (base-attack (if (is-eq rarity "legendary") u50 
                  (if (is-eq rarity "rare") u30 
                    (if (is-eq rarity "common") u10 u20))))
    (base-defense (if (is-eq rarity "legendary") u50 
                   (if (is-eq rarity "rare") u30 
                     (if (is-eq rarity "common") u10 u20))))
  )
    ;; Require minting fee
    (try! (stx-transfer? (var-get mint-fee) tx-sender (as-contract tx-sender)))

    ;; Create character in map
    (map-set characters 
      {id: character-id} 
      {
        name: name, 
        attack: base-attack,
        defense: base-defense,
        health: u100, 
        level: u1,
        rarity: rarity
      }
    )

    ;; Set character owner
    (map-set character-owners 
      {character-id: character-id} 
      {owner: tx-sender}
    )

    ;; Increment tracking variables
    (var-set next-character-id (+ character-id u1))
    (var-set total-characters (+ (var-get total-characters) u1))

    (ok character-id)
))

;; Battle Function
(define-public (battle 
  (attacker-id uint) 
  (defender-id uint)
)
  (let (
    (attacker-owner (unwrap! 
      (get-character-owner attacker-id) 
      (err ERR-INVALID-CHARACTER)
    ))
    (defender-owner (unwrap! 
      (get-character-owner defender-id) 
      (err ERR-INVALID-CHARACTER)
    ))
    (attacker-details (unwrap! 
      (get-character-details attacker-id) 
      (err ERR-INVALID-CHARACTER)
    ))
    (defender-details (unwrap! 
      (get-character-details defender-id) 
      (err ERR-INVALID-CHARACTER)
    ))
    (attack-power (get attack attacker-details))
    (defense-power (get defense defender-details))
    (winner-id (if (> attack-power defense-power) 
                  attacker-id 
                  defender-id))
  )
    ;; Prevent battling own characters
    (asserts! (not (is-eq attacker-owner defender-owner)) 
      (err ERR-BATTLE-NOT-ALLOWED))

    ;; Record battle in history
    (map-set battle-history 
      {battle-id: (var-get next-character-id)} 
      {
        attacker-id: attacker-id, 
        defender-id: defender-id, 
        winner-id: winner-id,
        timestamp: block-height
      }
    )

    (ok winner-id)
))

;; Character Level Up Function
(define-public (level-up (character-id uint))
  (let (
    (character (unwrap! 
      (get-character-details character-id) 
      (err ERR-INVALID-CHARACTER)
    ))
    (owner (unwrap! 
      (get-character-owner character-id) 
      (err ERR-INVALID-CHARACTER)
    ))
  )
    ;; Only owner can level up
    (asserts! (is-eq tx-sender owner) (err ERR-NOT-OWNER))

    ;; Increase character stats
    (map-set characters 
      {id: character-id} 
      (merge character {
        attack: (+ (get attack character) u5),
        defense: (+ (get defense character) u5),
        health: (+ (get health character) u10),
        level: (+ (get level character) u1)
      })
    )

    (ok true)
))

;; Read-only Functions for Character Details
(define-read-only (get-character-details (character-id uint))
  (map-get? characters {id: character-id})
)

(define-read-only (get-character-owner (character-id uint))
  (get owner (map-get? character-owners {character-id: character-id}))
)

;; Initialize the contract
(begin 
  (var-set mint-fee u10000000)  ;; 0.1 STX initial mint fee
  (var-set next-character-id u1)
  (var-set total-characters u0)
)