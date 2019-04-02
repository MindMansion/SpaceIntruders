//
//  GameScene.swift
//  SpaceIntruders
//
//  Created by MindMansion on 2019-04-01.
//  Copyright © 2019 MindMansion. All rights reserved.
//

import SpriteKit

enum CollisionType: UInt32  {
    case player = 1
    case playerWeapon = 2
    case enemy = 4
    case enemyWeapon = 8
    
}

class GameScene: SKScene {
    let player = SKSpriteNode(imageNamed: "player")
    
    let waves = Bundle.main.decode([Wave].self, from: "waves.json")
    let enemyTypes = Bundle.main.decode([EnemyType].self, from: "enemy-types.json")
    
    var isPlayerAlive = true
    var levelNumber = 0
    var waveNumber = 0
    
    let positions = Array(stride(from: -320, through: 320, by: 80))
    
    
    override func didMove(to view: SKView) {
        
        physicsWorld.gravity = .zero
        
        if let particles = SKEmitterNode(fileNamed: "Starfield"){
            particles.position = CGPoint(x: 1080, y: 0)
            particles.advanceSimulationTime(60)
            particles.zPosition = -1
            addChild(particles)
        }

        player.name = "player"
        player.position.x = frame.minX + 75
        player.zPosition = 1
        addChild(player)
        
        // Add physics body to player
        // NOTE to Self CollisionBitmask represents the things what will collide
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        player.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player.physicsBody?.collisionBitMask = CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
        
        
        // NOTOE to self, ContactTestBitMask are the things we'd like to notified about when collision takes place
        player.physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
        
        // handle player gravity
        player.physicsBody?.isDynamic = false
    
    }
    
    override func update(_ currentTime: TimeInterval) {
        for child in children {
            if child.frame.maxX < 0{
                if !frame.intersects(child.frame){
                   child.removeFromParent()
                }
            }
        }
        
        let activeEnemies = children.compactMap {$0 as? EnemyNode }
        if activeEnemies.isEmpty {
            createWave()
        }
        
        for enemy in activeEnemies {
            guard frame.intersects(enemy.frame) else {continue}
            
            if enemy.lastFireTime + 1 < currentTime {
                
                enemy.lastFireTime = currentTime
                
                if Int.random(in: 0...6) == 0{
                    enemy.fire()
            }
            }
        }
    }
    
    func createWave() {
        guard  isPlayerAlive else {return}
        
        if waveNumber == waves.count {
            levelNumber += 1
            waveNumber = 0
        }
        
        let currentWave = waves[waveNumber]
        waveNumber += 1
        
        let maximumEnemyType = min(enemyTypes.count, levelNumber + 1)
        let enemyType = Int.random(in: 0..<maximumEnemyType)
        
        let enemyOffsetX: CGFloat = 100
        let enemyStartX = 600
        
        if currentWave.enemies.isEmpty {
            for (index, positon) in positions.shuffled().enumerated() {
                
                let enemy = EnemyNode(type: enemyTypes[enemyType], startPosition: CGPoint(x: enemyStartX, y: positon), xOffset: enemyOffsetX * CGFloat(index * 3), moveStriaght: true)
                addChild(enemy)
            }
        }else {
            
            for enemy in currentWave.enemies {
                let node = EnemyNode(type: enemyTypes[enemyType], startPosition: CGPoint(x: enemyStartX, y: positions[enemy.position]), xOffset: enemyOffsetX * CGFloat(enemy.xOffset), moveStriaght: enemy.moveStraight)
                
                addChild(node)
            }
        }
        
    }
}
