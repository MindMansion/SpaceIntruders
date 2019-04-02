//
//  waves.swift
//  SpaceIntruders
//
//  Created by MindMansion on 2019-04-01.
//  Copyright © 2019 MindMansion. All rights reserved.
//

import SpriteKit

struct Wave: Codable {
    struct WaveEnemy: Codable {
        let position: Int
        let xOffset: CFloat
        let moveStraight: Bool
        
    }
    
    let name: String
    let enemies: [WaveEnemy]
}
