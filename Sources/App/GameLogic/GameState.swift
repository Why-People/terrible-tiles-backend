//
//  File.swift
//  
//
//  Created by Matthew Hayes on 5/13/22.
//

import Foundation

// MARK: - Main Class

/// Class Containing main game logic
class GameState {
    private(set) var filledTiles = Defaults.filledTiles
    private(set) var playerPosition = Defaults.playerPosition
    private(set) var isDead = Defaults.isDead
    private(set) var itemScore = Defaults.itemScore
    private(set) var startedAt = Defaults.startedAt
    private(set) var rngFactor = Defaults.rngFactor
    
    init(
        filledTiles: [Position: TileType] = Defaults.filledTiles,
        playerPosition: Position = Defaults.playerPosition,
        isDead: Bool = Defaults.isDead,
        itemScore: Int = Defaults.itemScore,
        startedAt: Date = Defaults.startedAt,
        rngFactor: RNGFactor = Defaults.rngFactor
    ) {
        self.filledTiles = filledTiles
        self.playerPosition = playerPosition
        self.isDead = isDead
        self.itemScore = itemScore
        self.startedAt = startedAt
        self.rngFactor = rngFactor
    }
    
    /// Update Game State based on the input command
    func processInput(command: InputCommand) {
        if command == .leave {
            self.isDead = true
        } else {
            self.processMovement(command)
        }
    }
    
    private func processMovement(_ command: InputCommand) {
        self.updatePlayerPosition(command)
        self.updateGameStatus()
    }
    
    private func updatePlayerPosition(_ command: InputCommand) {
        switch command {
        case .moveUp:
            if self.playerPosition.y > 0 {
                self.playerPosition = .init(x: self.playerPosition.x, y: self.playerPosition.y - 1)
            }
        case .moveDown:
            if self.playerPosition.y < Constants.maxRows - 1 {
                self.playerPosition = .init(x: self.playerPosition.x, y: self.playerPosition.y + 1)
            }
        case .moveLeft:
            if self.playerPosition.x > 0 {
                self.playerPosition = .init(x: self.playerPosition.x - 1, y: self.playerPosition.y)
            }
        case .moveRight:
            if self.playerPosition.x < Constants.maxCols - 1 {
                self.playerPosition = .init(x: self.playerPosition.x + 1, y: self.playerPosition.y)
            }
        default:
            return
        }
    }
    
    private func updateGameStatus() {
        guard let playerTile = self.filledTiles[self.playerPosition] else { return }
        if playerTile != .void {
            self.itemScore += playerTile.scoreValue
        } else {
            self.isDead = true
        }
        self.filledTiles.removeValue(forKey: self.playerPosition)
    }
}

// MARK: - Constants

extension GameState {
    enum Constants {
        // An Odd number can keep the positioning somewhat symetrical
        static let maxRows = 15
        static let maxCols = 25
    }
}

// MARK: - Defaults

extension GameState {
    enum Defaults {
        static let filledTiles = [Position: TileType]()
        static let playerPosition = Position(x: 12, y: 7)
        static let isDead = false
        static let itemScore = 0
        static let startedAt = Date.now
        static let rngFactor = RNGFactor.time
    }
}
