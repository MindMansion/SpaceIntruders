//
//  EnemyType.swift
//  SpaceIntruders
//
//  Created by MindMansion on 2019-04-01.
//  Copyright © 2019 MindMansion. All rights reserved.
//

import SpriteKit

struct EnemyType: Codable {
    let name: String
    let shields: Int
    let speed: CGFloat
    let powerUpChance: Int
}
